// test/user_screen_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ========================================================================= //
// BEGINNING OF TestUserScreen WIDGET DEFINITION                             //
// (This is the widget being tested, included here for self-containment)     //
// ========================================================================= //

class TestUserScreen extends StatelessWidget {
  final bool showUnauthenticated;
  final bool showLoadingData;
  final Map<String, dynamic>? userData;

  const TestUserScreen({
    super.key,
    this.showUnauthenticated = false,
    this.showLoadingData = false,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    if (showUnauthenticated) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back9.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'User not authenticated',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Image.asset('assets/images/renace.png', height: 30),
          ),
        ),
        backgroundColor: Colors.grey.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 30, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back9.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileSection(),
              _buildStatsSection(),
              _buildPersonalGoalSection(),
              _buildPersonalInfoSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: 'Inspire'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: userData?['photoURL'] != null
                ? NetworkImage(userData!['photoURL'])
                : const AssetImage('assets/images/user.jpg') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            userData?['usuario'] ?? 'Test User',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            showLoadingData
                ? 'Progress days: 0'
                : 'Progress days: ${userData?['totalDays'] ?? 1}',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text('General Progress',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 90.0,
            lineWidth: 24.0,
            percent: (userData?['progressPercentage'] ?? 0.0)
                .toDouble()
                .clamp(0.0, 1.0),
            center: Text(
              showLoadingData
                  ? '...'
                  : '${((userData?['progressPercentage'] ?? 0.0) * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            progressColor: Colors.purple[800]!,
            backgroundColor: Colors.purple.shade100.withOpacity(0.5),
          ),
          const SizedBox(height: 40),
          _buildStatCard(
            'Completed Tasks',
            userData?['completedTasksCount'] ?? 0,
            Icons.playlist_add_check_rounded,
            Colors.green.shade700,
            key: const Key('stat_card_completed_tasks'),
          ),
          const SizedBox(height: 40),
          _buildStatCard(
            'Current Streak',
            userData?['streakDays'] ?? 0,
            Icons.local_fire_department_rounded,
            Colors.deepOrange.shade600,
            key: const Key('stat_card_streak_days'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color iconColor,
      {Key? key}) {
    return Column(
      key: key,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100.withOpacity(0.8),
          ),
          child: Icon(icon, size: 85, color: iconColor),
        ),
        const SizedBox(height: 14),
        Text(
          showLoadingData ? '...' : '$count',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPersonalGoalSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('My Personal Goal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.edit, size: 24),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userData?['metaPersonal']?.isNotEmpty == true
                ? userData!['metaPersonal']
                : 'Tap the edit icon to add your goal',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          RichText(
            key: const Key('personal_info_name'),
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                    text: 'Full name: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: userData?['usuario'] ?? 'Test User'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            key: const Key('personal_info_email'),
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                    text: 'Email: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: userData?['correo'] ?? 'test@example.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================= //
// END OF TestUserScreen WIDGET DEFINITION                                 //
// ======================================================================= //

// ======================================================================= //
// BEGINNING OF TEST CODE (MAIN FUNCTION AND TESTS)                      //
// ======================================================================= //

void main() {
  // <--- THIS IS THE ENTRY POINT FOR THE TESTS
  Future<void> pumpTestUserScreen(
    WidgetTester tester, {
    bool showUnauthenticated = false,
    bool showLoadingData = false,
    Map<String, dynamic>? userData,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestUserScreen(
          showUnauthenticated: showUnauthenticated,
          showLoadingData: showLoadingData,
          userData: userData,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('UserScreen Widget Tests', () {
    testWidgets('Shows unauthenticated user screen',
        (WidgetTester tester) async {
      await pumpTestUserScreen(tester, showUnauthenticated: true);

      expect(find.text('User not authenticated'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Shows basic elements of the main screen',
        (WidgetTester tester) async {
      await pumpTestUserScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Inspire'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Shows profile information correctly',
        (WidgetTester tester) async {
      final userData = {
        'usuario': 'Juan Pérez',
        'totalDays': 15,
        'correo': 'juan@example.com',
      };
      await pumpTestUserScreen(tester, userData: userData);

      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('Progress days: 15'), findsOneWidget);

      final nameRichText =
          tester.widget<RichText>(find.byKey(const Key('personal_info_name')));
      expect(nameRichText.text.toPlainText(), equals('Full name: Juan Pérez'));

      final emailRichText =
          tester.widget<RichText>(find.byKey(const Key('personal_info_email')));
      expect(
          emailRichText.text.toPlainText(), equals('Email: juan@example.com'));
    });

    testWidgets('Shows statistics with data', (WidgetTester tester) async {
      final userData = {
        'progressPercentage': 0.25,
        'completedTasksCount': 5,
        'streakDays': 3,
      };
      await pumpTestUserScreen(tester, userData: userData);

      expect(find.text('General Progress'), findsOneWidget);
      expect(find.text('25.0%'), findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(const Key('stat_card_completed_tasks')),
              matching: find.text('Completed Tasks')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(const Key('stat_card_completed_tasks')),
              matching: find.text('5')),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(const Key('stat_card_streak_days')),
              matching: find.text('Current Streak')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(const Key('stat_card_streak_days')),
              matching: find.text('3')),
          findsOneWidget);
    });

    testWidgets('Shows circular progress indicator',
        (WidgetTester tester) async {
      await pumpTestUserScreen(tester);
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
    });

    testWidgets('Shows empty personal goal by default',
        (WidgetTester tester) async {
      await pumpTestUserScreen(tester);
      expect(find.text('My Personal Goal'), findsOneWidget);
      expect(find.text('Tap the edit icon to add your goal'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Shows personal goal with content',
        (WidgetTester tester) async {
      final userData = {'metaPersonal': 'Be more productive daily'};
      await pumpTestUserScreen(tester, userData: userData);
      expect(find.text('Be more productive daily'), findsOneWidget);
    });

    testWidgets('Shows loading state', (WidgetTester tester) async {
      await pumpTestUserScreen(tester, showLoadingData: true);

      expect(
          find.descendant(
              of: find.byType(CircularPercentIndicator),
              matching: find.text('...')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(const Key('stat_card_completed_tasks')),
              matching: find.text('...')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byKey(const Key('stat_card_streak_days')),
              matching: find.text('...')),
          findsOneWidget);
      expect(find.text('Progress days: 0'), findsOneWidget);
    });

    testWidgets('Avatar is displayed correctly', (WidgetTester tester) async {
      await pumpTestUserScreen(tester);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
