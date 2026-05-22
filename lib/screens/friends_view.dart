import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/network_provider.dart';
import '../models/user_model.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final _globalSearchController = TextEditingController();
  String _existingFriendsQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<NetworkProvider>(context, listen: false).init(userId);
      }
    });
  }

  void _handleGlobalSearch(String value) {
    if (value.trim().isNotEmpty) {
      Provider.of<NetworkProvider>(context, listen: false).searchUsers(value.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final networkProvider = Provider.of<NetworkProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.user?.uid;

    final filteredFriends = networkProvider.friends.where((friend) {
      if (currentUserId != null && friend.id == currentUserId) return false;
      return friend.name.toLowerCase().contains(_existingFriendsQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Travel Network', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_rounded, color: Color(0xFF0D9488)),
            onPressed: () async {
              if (currentUserId != null) {
                await networkProvider.seedDummyData(currentUserId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dummy Data Added to Firestore! Refreshing...'))
                );
              }
            },
            tooltip: 'Seed Dummy Data',
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (currentUserId != null) {
            networkProvider.init(currentUserId);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔎 Search Bar
              TextField(
                onChanged: (val) => setState(() => _existingFriendsQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D9488)),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              // 📥 SECTION 1: Friend Requests (Instagram Style)
              if (networkProvider.pendingRequests.isNotEmpty) ...[
                Text('Friend Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: networkProvider.pendingRequests.length,
                  itemBuilder: (context, index) {
                    final req = networkProvider.pendingRequests[index];
                    final user = req.user;
                    return _buildRequestTile(context, req.requestId, user, currentUserId!, theme, networkProvider);
                  },
                ),
                const SizedBox(height: 24),
              ],

              // ➕ SECTION 2: Find New Friends
              Text('Find New Travelers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              TextField(
                controller: _globalSearchController,
                onSubmitted: _handleGlobalSearch,
                decoration: InputDecoration(
                  hintText: 'Search by email...',
                  prefixIcon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0D9488)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Color(0xFF0D9488)),
                    onPressed: () => _handleGlobalSearch(_globalSearchController.text),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              
              // Search Results
              if (networkProvider.isSearching || networkProvider.searchResults.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(14)),
                  child: networkProvider.isSearching 
                    ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()))
                    : Column(
                        children: networkProvider.searchResults.map((user) => ListTile(
                          leading: CircleAvatar(child: Text(user.name[0])),
                          title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user.email),
                          trailing: ElevatedButton(
                            onPressed: () {
                              networkProvider.sendRequest(currentUserId!, user.id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request sent to ${user.name}')));
                              _globalSearchController.clear();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
                            child: const Text('Connect', style: TextStyle(color: Colors.white)),
                          ),
                        )).toList(),
                      ),
                ),
              ],
              const SizedBox(height: 24),

              // ✨ SECTION 3: Suggested Friends (Dummy Data)
              Text('Suggested for you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              _buildSuggestedTile(theme, "Arsalan Ahmed", "arsalan@travel.com", "https://i.pravatar.cc/150?u=1"),
              _buildSuggestedTile(theme, "Fatima Zehra", "fatima@sync.com", "https://i.pravatar.cc/150?u=2"),
              _buildSuggestedTile(theme, "Hamza Ali", "hamza@safar.com", "https://i.pravatar.cc/150?u=3"),
              
              const SizedBox(height: 24),

              // 👥 SECTION 4: My Circle (Friends List)
              Text('My Circle (${networkProvider.friends.length})', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              if (filteredFriends.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No friends yet. Start connecting!')))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(friend.name[0])),
                        title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(friend.email),
                        trailing: const Icon(Icons.chat_bubble_outline, color: Color(0xFF0D9488)),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestTile(BuildContext context, String requestId, UserModel user, String currentUserId, ThemeData theme, NetworkProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.dividerColor)),
      child: Row(
        children: [
          CircleAvatar(radius: 25, child: Text(user.name[0])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(user.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => provider.acceptRequest(requestId, currentUserId, user.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => provider.declineRequest(requestId),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedTile(ThemeData theme, String name, String email, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(email),
        trailing: TextButton(
          onPressed: () {},
          child: const Text('Follow', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
