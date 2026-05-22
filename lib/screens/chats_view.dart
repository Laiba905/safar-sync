import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/network_provider.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../database_service.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<TripProvider>(context, listen: false).fetchUserTrips(userId);
        Provider.of<NetworkProvider>(context, listen: false).init(userId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripProvider = Provider.of<TripProvider>(context);
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0D9488),
          labelColor: const Color(0xFF0D9488),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Direct'),
            Tab(text: 'Groups'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D9488)),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDirectChats(networkProvider, theme),
                _buildGroupChats(tripProvider, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectChats(NetworkProvider networkProvider, ThemeData theme) {
    final friends = networkProvider.friends.where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    if (friends.isEmpty) return const Center(child: Text("No friends yet"));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return _buildChatTile(
          context: context,
          theme: theme,
          title: friend.name,
          subtitle: 'Start a conversation',
          icon: Icons.person,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IndividualChatRoom(friend: friend)),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupChats(TripProvider tripProvider, ThemeData theme) {
    final trips = tripProvider.trips?.where((t) => t.destination.toLowerCase().contains(_searchQuery.toLowerCase())).toList() ?? [];
    if (trips.isEmpty) return const Center(child: Text("No group trips found"));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildChatTile(
          context: context,
          theme: theme,
          title: trip.destination,
          subtitle: 'Trip group chat',
          icon: Icons.landscape,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroupChatRoomScreen(trip: trip)),
            );
          },
        );
      },
    );
  }

  Widget _buildChatTile({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
          child: Icon(icon, color: const Color(0xFF0D9488)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF0D9488)),
        onTap: onTap,
      ),
    );
  }
}

class IndividualChatRoom extends StatefulWidget {
  final UserModel friend;
  const IndividualChatRoom({super.key, required this.friend});

  @override
  State<IndividualChatRoom> createState() => _IndividualChatRoomState();
}

class _IndividualChatRoomState extends State<IndividualChatRoom> {
  final _messageController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  void _sendPrivateMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final currentUserId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (currentUserId != null) {
        _dbService.sendPrivateMessage(currentUserId, widget.friend.id, text);
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUserId = Provider.of<AuthProvider>(context).user?.uid;

    if (currentUserId == null) return const Scaffold(body: Center(child: Text("Please login")));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.friend.avatarUrl != null ? NetworkImage(widget.friend.avatarUrl!) : null,
              child: widget.friend.avatarUrl == null ? Text(widget.friend.name[0]) : null,
            ),
            const SizedBox(width: 10),
            Text(widget.friend.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: theme.cardColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _dbService.getPrivateMessages(currentUserId, widget.friend.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet. Say Hi!", style: TextStyle(color: theme.hintColor)));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFF0D9488) : theme.cardColor,
                          borderRadius: BorderRadius.circular(16).copyWith(
                            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                          ),
                        ),
                        child: Text(
                          data['text'] ?? '',
                          style: TextStyle(color: isMe ? Colors.white : theme.colorScheme.onSurface),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.cardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
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
                    onPressed: _sendPrivateMessage,
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

class GroupChatRoomScreen extends StatefulWidget {
  final TripModel trip;
  const GroupChatRoomScreen({super.key, required this.trip});

  @override
  State<GroupChatRoomScreen> createState() => _GroupChatRoomScreenState();
}

class _GroupChatRoomScreenState extends State<GroupChatRoomScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripProvider>(context, listen: false).listenToChat(widget.trip.id);
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<TripProvider>(context, listen: false).sendMessage(widget.trip.id, userId, text);
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripProvider = Provider.of<TripProvider>(context);
    final currentUserId = Provider.of<AuthProvider>(context).user?.uid;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.trip.destination, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: theme.cardColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: tripProvider.chatMessages?.length ?? 0,
              itemBuilder: (context, index) {
                final messages = tripProvider.chatMessages ?? [];
                if (messages.isEmpty) return const SizedBox();
                final doc = messages[index];
                final data = doc.data() as Map<String, dynamic>;
                final isMe = data['senderId'] == currentUserId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF0D9488) : theme.cardColor,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                        bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                      ),
                    ),
                    child: Text(
                      data['text'] ?? '',
                      style: TextStyle(color: isMe ? Colors.white : theme.colorScheme.onSurface),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.cardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
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
                    onPressed: _sendMessage,
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
