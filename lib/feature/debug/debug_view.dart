import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';

class DebugView extends StatelessWidget {
  const DebugView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Debug Information'),
            backgroundColor: context.primary,
            foregroundColor: context.onPrimary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuthenticationFlagsSection(appState),
                const SizedBox(height: 24),
                _buildSharedPreferencesSection(),
                const SizedBox(height: 24),
                _buildUserTokenSection(appState),
                const SizedBox(height: 24),
                _buildAppStateSection(appState),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthenticationFlagsSection(AppStateProvider appState) {
    return _buildSection(
      title: '🔐 Authentication Flow Flags',
      children: [
        _buildFlagItem(
          'Google Auth Data Persisted',
          appState.isGoogleAuthDataPersisted,
        ),
        _buildFlagItem(
          'User Data Loaded from Shared',
          appState.isUserDataLoadedFromShared,
        ),
        _buildFlagItem(
          'Backend Authentication Sent',
          appState.isBackendAuthenticationSent,
        ),
        _buildFlagItem(
          'Backend Authentication Confirmed',
          appState.isBackendAuthenticationConfirmed,
        ),
        _buildFlagItem('Token Saved', appState.isTokenSaved),
        _buildFlagItem('User Data Saved', appState.isUserDataSaved),
      ],
    );
  }

  Widget _buildSharedPreferencesSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: SharedPreferencesService.getAllOAuthData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSection(
            title: '💾 SharedPreferences Data',
            children: [
              _buildDataItem('Status', 'Loading...'),
            ],
          );
        }

        if (snapshot.hasError) {
          return _buildSection(
            title: '💾 SharedPreferences Data',
            children: [
              _buildDataItem('Error', 'Failed to load data'),
            ],
          );
        }

        final allData = snapshot.data ?? {};
        final keys = allData.keys.toList()..sort();

        return _buildSection(
          title: '💾 SharedPreferences Data',
          children: [
            ...keys.map(
              (key) => _buildDataItem(key, allData[key]?.toString() ?? 'null'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserTokenSection(AppStateProvider appState) {
    final currentUser = appState.currentUser;

    return _buildSection(
      title: '🔑 User Token Information',
      children: [
        _buildDataItem(
          'Has Access Token',
          currentUser?.accessToken != null ? 'Yes' : 'No',
        ),
        if (currentUser?.accessToken != null) ...[
          _buildDataItem(
            'Token Length',
            '${currentUser!.accessToken!.length} characters',
          ),
          _buildDataItem(
            'Token Preview',
            '${currentUser.accessToken!.substring(0, 10)}...',
          ),
        ],
        _buildDataItem('Provider', currentUser?.provider ?? 'No user'),
        _buildDataItem(
          'Provider User ID',
          currentUser?.providerUserId ?? 'No user',
        ),
        _buildDataItem('Email', currentUser?.email ?? 'No user'),
        _buildDataItem('User Name', currentUser?.userName ?? 'No user'),
        _buildDataItem(
          'Created At',
          currentUser?.createdAt.toIso8601String() ?? 'No user',
        ),
        _buildDataItem(
          'Last Login',
          currentUser?.lastLogin.toIso8601String() ?? 'No user',
        ),
        _buildDataItem(
          'Is Active',
          currentUser?.isActive.toString() ?? 'No user',
        ),
        _buildDataItem(
          'Approved',
          currentUser?.approved.toString() ?? 'No user',
        ),
      ],
    );
  }

  Widget _buildAppStateSection(AppStateProvider appState) {
    return _buildSection(
      title: '📱 App State',
      children: [
        _buildDataItem('Is Authenticated', appState.isAuthenticated.toString()),
        _buildDataItem(
          'Current User',
          appState.currentUser?.userName ?? 'No user',
        ),
        _buildDataItem('Dark Mode', appState.isDarkMode.toString()),
        _buildDataItem('Language', appState.currentLanguage),
        _buildDataItem(
          'Notifications',
          appState.notificationsEnabled.toString(),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFlagItem(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  value
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value ? 'TRUE' : 'FALSE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: value ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
