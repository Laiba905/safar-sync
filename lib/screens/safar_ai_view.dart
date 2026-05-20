import 'package:flutter/material.dart';

class SafarAiView extends StatefulWidget {
  const SafarAiView({super.key});

  @override
  State<SafarAiView> createState() => _SafarAiViewState();
}

class _SafarAiViewState extends State<SafarAiView> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  String? _aiResponse;

  // Premium Suggested Travel Badges
  final List<String> _suggestions = [
    'Explore Swat for 3 days 🏔️',
    'Beach trip to Karachi 🌊',
    'Hunza Valley itinerary 🗺️',
  ];

  void _handleSendPlan() {
    if (_promptController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = null;
    });

    // Mocking OpenRouter API latency for beautiful user testing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _aiResponse = "✨ Here is your custom dynamic itinerary for '${_promptController.text}':\n\n"
            "🗓️ Day 1: Departure & Arrival checks, local market dinner view.\n"
            "📸 Day 2: Main sightseeing spots explore and historical spots visit.\n"
            "🚗 Day 3: Packing bags and smooth return tracking.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('SafarAI Plan Generator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800), // Keeps the layout clean and centralized on web screen views
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // Dynamic Icon Container based on load status
                      if (!_isLoading && _aiResponse == null) ...[
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 72,
                          color: Color(0xFF0D9488),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Where do you want to travel next?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Our AI engine will instantly curate personalized dynamic schedules for you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
                        ),
                        const SizedBox(height: 32),

                        // 🌟 Premium Enhancement: Quick Click Suggestions Chips
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: _suggestions.map((suggestion) {
                            return ActionChip(
                              label: Text(suggestion),
                              labelStyle: const TextStyle(color: Color(0xFF0D9488), fontSize: 13, fontWeight: FontWeight.w500),
                              backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.06),
                              side: BorderSide(color: const Color(0xFF0D9488).withValues(alpha: 0.2)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                _promptController.text = suggestion;
                              },
                            );
                          }).toList(),
                        ),
                      ] else if (_isLoading) ...[
                        const SizedBox(height: 100),
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Curating your premium smart itinerary...',
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontStyle: FontStyle.italic),
                        ),
                      ] else if (_aiResponse != null) ...[
                        // Beautiful AI Markdown-like Response Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome_rounded, color: Color(0xFF0D9488), size: 20),
                                  const SizedBox(width: 8),
                                  Text('SafarAI Schedule', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 16)),
                                ],
                              ),
                              const Divider(height: 24),
                              Text(
                                _aiResponse!,
                                style: const TextStyle(fontSize: 15, height: 1.5),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _promptController.clear();
                                      _aiResponse = null;
                                    });
                                  },
                                  icon: const Icon(Icons.refresh_rounded, size: 18),
                                  label: const Text('Plan Another Trip'),
                                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF0D9488)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ==========================================
              // ✉️ INPUT BAR AREA: Prompt Input With Send Icon
              // ==========================================
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _promptController,
                          onSubmitted: (_) => _handleSendPlan(),
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'e.g., Explore Swat for 3 days...',
                            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    // 🛠️ FIX ADDED: Beautiful Teal Send Avatar Button
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF0D9488),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                          onPressed: _handleSendPlan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}