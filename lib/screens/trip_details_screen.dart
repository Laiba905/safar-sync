import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trip_provider.dart';
import '../providers/auth_provider.dart';
import '../models/expense_model.dart';

class TripDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ SAFETY UPDATED: Dynamic state parse parsing for real-time safe fetching
      double lat = 0.0;
      double lon = 0.0;

      if (widget.trip['latitude'] != null) lat = (widget.trip['latitude'] as num).toDouble();
      if (widget.trip['longitude'] != null) lon = (widget.trip['longitude'] as num).toDouble();

      dynamic rawDate = widget.trip['startDate'];
      DateTime startDate = DateTime.now();
      if (rawDate is DateTime) {
        startDate = rawDate;
      } else if (rawDate is String) {
        startDate = DateTime.tryParse(rawDate) ?? DateTime.now();
      }

      String formattedDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";

      final tripProvider = Provider.of<TripProvider>(context, listen: false);

      // Real-time API configuration calls fixed
      tripProvider.fetchWeatherForTripDay(lat, lon, formattedDate);
      tripProvider.fetchWeather(lat, lon); // Fetch 5-day forecast

      String? tripId = widget.trip['id'];
      if (tripId != null) {
        tripProvider.listenToExpenses(tripId);
        tripProvider.listenToItinerary(tripId);
        List<dynamic> members = widget.trip['members'] ?? [];
        tripProvider.fetchMemberNames(members);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddExpenseDialog(BuildContext context, String tripId, List<dynamic> members) {
    final TextEditingController descController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.uid ?? '';
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final currentUserName = tripProvider.memberNames[currentUserId] ?? 'Me';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Add New Expense", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Amount (\$)", labelStyle: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
              onPressed: () async {
                final String desc = descController.text.trim();
                final double? amountValue = double.tryParse(amountController.text.trim());

                if (desc.isNotEmpty && amountValue != null && amountValue > 0) {
                  List<String> stringMembers = members.map((e) => e.toString()).toList();
                  if (!stringMembers.contains(currentUserId)) stringMembers.add(currentUserId);

                  await tripProvider.addExpense(tripId, description: desc, totalAmount: amountValue, payerId: currentUserId, payerName: currentUserName, splitAmong: stringMembers);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showEditExpenseDialog(BuildContext context, String tripId, ExpenseModel expense) {
    final TextEditingController descController = TextEditingController(text: expense.description);
    final TextEditingController amountController = TextEditingController(text: expense.amount.toString());
    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Expense", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Amount (\$)", labelStyle: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
              onPressed: () async {
                final String desc = descController.text.trim();
                final double? amountValue = double.tryParse(amountController.text.trim());

                if (desc.isNotEmpty && amountValue != null && amountValue > 0) {
                  await tripProvider.editExpense(tripId, expense.id, description: desc, totalAmount: amountValue);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeatherMainCard(Map<String, dynamic> weather) {
    double temp = (weather['main']['temp'] as num).toDouble();
    String condition = weather['weather'][0]['main'];
    String desc = weather['weather'][0]['description'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Icon(Icons.wb_sunny_rounded, size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          Text("$temp°C", style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Text(condition, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
          const SizedBox(height: 4),
          Text("Expectation: $desc", style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildForecastItem(Map<String, dynamic> day) {
    double temp = (day['main']['temp'] as num).toDouble();
    String condition = day['weather'][0]['main'];
    String dateStr = day['dt_txt'];
    DateTime date = DateTime.parse(dateStr);
    String formattedDate = "${date.day} ${_getMonth(date.month)}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formattedDate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(condition, style: const TextStyle(color: Color(0xFF0D9488), fontSize: 12)),
            ],
          ),
          Row(
            children: [
              Icon(_getWeatherIcon(condition), color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Text("$temp°C", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds': return Icons.cloud_rounded;
      case 'rain': return Icons.umbrella_rounded;
      case 'clear': return Icons.wb_sunny_rounded;
      case 'snow': return Icons.ac_unit_rounded;
      default: return Icons.wb_cloudy_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String tripTitle = widget.trip['title'] ?? '';
    final String destination = widget.trip['destination'] ?? 'Unknown';
    final String tripId = widget.trip['id'] ?? '';
    List<dynamic> members = widget.trip['members'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(tripTitle.isNotEmpty ? tripTitle : destination, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0D9488),
          labelColor: const Color(0xFF0D9488),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(icon: Icon(Icons.cloud_outlined, size: 22), text: "Weather"),
            Tab(icon: Icon(Icons.payments_outlined, size: 22), text: "Expenses"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- TAB 1: WEATHER DATA VIEWER ---
          Consumer<TripProvider>(
            builder: (context, tripProvider, child) {
              if (tripProvider.isWeatherLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)));
              
              final forecast = tripProvider.forecast;
              final current = tripProvider.specificDayWeather;

              if (forecast.isEmpty && current == null) {
                return const Center(child: Text("Weather data unavailable", style: TextStyle(color: Colors.grey)));
              }

              return ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  if (current != null) ...[
                    const Text("Today's Forecast", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildWeatherMainCard(current),
                    const SizedBox(height: 24),
                  ],
                  if (forecast.isNotEmpty) ...[
                    const Text("Upcoming Days", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...forecast.map((day) => _buildForecastItem(day)).toList(),
                  ],
                ],
              );
            },
          ),

          // --- TAB 2: EXPENSES SYSTEM ---
          Consumer<TripProvider>(
            builder: (context, tripProvider, child) {
              final expenseList = tripProvider.expenses;
              double totalTripBudget = expenseList.fold(0.0, (sum, item) => sum + item.amount);

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF0D9488)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Group Expenses", style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text("\$${totalTripBudget.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: expenseList.isEmpty
                          ? const Center(child: Text("No expenses recorded yet.", style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: expenseList.length,
                        itemBuilder: (context, index) {
                          final ExpenseModel expense = expenseList[index];
                          double perPersonSplit = expense.amount / (expense.splitAmong.isNotEmpty ? expense.splitAmong.length : 1);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
                                child: const Icon(Icons.monetization_on_rounded, color: Color(0xFF0D9488)),
                              ),
                              title: Text(
                                expense.description,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Paid by: ${expense.payerName}\nSplit: \$${perPersonSplit.toStringAsFixed(2)} / person",
                                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, height: 1.3),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "\$${expense.amount.toStringAsFixed(1)}",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: Colors.amber, size: 20),
                                    onPressed: () => _showEditExpenseDialog(context, tripId, expense),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                    onPressed: () async {
                                      await tripProvider.deleteExpense(tripId, expense.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  onPressed: () => _showAddExpenseDialog(context, tripId, members),
                  child: const Icon(Icons.add_card_rounded, size: 24),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}