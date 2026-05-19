import 'package:flutter/material.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();

  // Hardcoded temporary values for dropdowns
  String _selectedMode = 'By Car';
  final List<String> _travelModes = ['By Car', 'By Bus', 'By Bike', 'By Air'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Plan New Journey',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where are you heading?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'Fill in the details to find your perfect travel squad.',
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: 28),

              // 📍 Destination Input
              _buildInputLabel('Destination', theme),
              _buildCustomTextField(
                hint: 'e.g. Hunza Valley, Skardu',
                icon: Icons.location_on_outlined,
                theme: theme,
              ),
              const SizedBox(height: 20),

              // 📅 Date Picker Placeholder
              _buildInputLabel('Travel Dates', theme),
              _buildClickablePlaceholder(
                hint: 'Select Start & End Date',
                icon: Icons.calendar_today_rounded,
                theme: theme,
                onTap: () {
                  // Future: Mahnoor will show showDateRangePicker here
                },
              ),
              const SizedBox(height: 20),

              // 🚗 Travel Mode Dropdown
              _buildInputLabel('Travel Mode', theme),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMode,
                    isExpanded: true,
                    dropdownColor: theme.cardColor,
                    style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    items: _travelModes.map((String mode) {
                      return DropdownMenuItem<String>(
                        value: mode,
                        child: Text(mode),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMode = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 💰 Estimated Budget
              _buildInputLabel('Estimated Budget (PKR)', theme),
              _buildCustomTextField(
                hint: 'e.g. 25000',
                icon: Icons.wallet_outlined,
                theme: theme,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),

              // 🚀 Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Future: Save trip blueprint logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Create Trip Blueprint',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Input Labels
  Widget _buildInputLabel(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.8)),
      ),
    );
  }

  // Helper: Text Fields
  Widget _buildCustomTextField({required String hint, required IconData icon, required ThemeData theme, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF0D9488), size: 22),
        filled: true,
        fillColor: theme.cardColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
      ),
    );
  }

  // Helper: Clickable box placeholders (for dates)
  Widget _buildClickablePlaceholder({required String hint, required IconData icon, required ThemeData theme, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0D9488), size: 22),
            const SizedBox(width: 12),
            Text(
              hint,
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}