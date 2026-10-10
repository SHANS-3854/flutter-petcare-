
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const PetCareApp());
}

const Color ink = Color(0xFF172C28);
const Color mint = Color(0xFFBDE8D5);
const Color cream = Color(0xFFF5F7F2);
const Color muted = Color(0xFF7B8983);

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF39866C),
          surface: cream,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class Pet {
  String name;
  String breed;
  String emoji;
  int age;

  Pet({
    required this.name,
    required this.breed,
    required this.emoji,
    required this.age,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedTab = 0;

  final List<Pet> pets = [
    Pet(name: 'Bruno', breed: 'Golden Retriever', emoji: '🐕', age: 2),
    Pet(name: 'Milo', breed: 'Persian Cat', emoji: '🐈', age: 1),
  ];

  final List<Map<String, dynamic>> reminders = [
    {
      'title': 'Morning feeding',
      'subtitle': 'Bruno · Today, 8:00 AM',
      'icon': Icons.restaurant_rounded,
      'done': false,
    },
    {
      'title': 'Vaccination check',
      'subtitle': 'Milo · Today, 4:30 PM',
      'icon': Icons.vaccines_rounded,
      'done': false,
    },
    {
      'title': 'Evening walk',
      'subtitle': 'Bruno · Today, 6:00 PM',
      'icon': Icons.directions_walk_rounded,
      'done': true,
    },
  ];

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void addPet() {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final ageController = TextEditingController(text: '1');
    String emoji = '🐕';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, refreshDialog) {
            return AlertDialog(
              backgroundColor: cream,
              title: const Text('Add your pet'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 12,
                      children: ['🐕', '🐈', '🐇', '🐦', '🐹']
                          .map(
                            (item) => GestureDetector(
                              onTap: () => refreshDialog(
                                () => emoji = item,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: emoji == item
                                      ? mint
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Pet name',
                      ),
                    ),
                    TextField(
                      controller: breedController,
                      decoration: const InputDecoration(
                        labelText: 'Breed',
                      ),
                    ),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age in years',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    setState(() {
                      pets.add(
                        Pet(
                          name: name,
                          breed: breedController.text.trim().isEmpty
                              ? 'Pet'
                              : breedController.text.trim(),
                          emoji: emoji,
                          age: int.tryParse(ageController.text) ?? 1,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                    showMessage('$name added successfully');
                  },
                  child: const Text('Add pet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addReminder() {
    final titleController = TextEditingController();
    final petController = TextEditingController(
      text: pets.isNotEmpty ? pets.first.name : '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cream,
        title: const Text('New reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Reminder',
                hintText: 'e.g. Give medicine',
              ),
            ),
            TextField(
              controller: petController,
              decoration: const InputDecoration(
                labelText: 'Pet name',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;

              setState(() {
                reminders.add({
                  'title': titleController.text.trim(),
                  'subtitle':
                      '${petController.text.trim()} · Today',
                  'icon': Icons.notifications_active_rounded,
                  'done': false,
                });
              });

              Navigator.pop(dialogContext);
              showMessage('Reminder added');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      buildPets(),
      buildHealth(),
      buildReminders(),
      buildProfile(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: selectedTab,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedTab,
          backgroundColor: Colors.transparent,
          indicatorColor: mint,
          height: 72,
          onDestinationSelected: (index) {
            setState(() => selectedTab = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets_rounded),
              label: 'Pets',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Health',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: 'Reminders',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHome() {
    final pending = reminders.where((r) => r['done'] != true).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
      children: [
        Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.pets_rounded,
                color: ink,
                size: 27,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PETCARE',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.1,
                      fontSize: 17,
                      color: ink,
                    ),
                  ),
                  Text(
                    'A little love, every day.',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => setState(() => selectedTab = 4),
              icon: const Icon(Icons.person_outline_rounded),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          'Good day!',
          style: TextStyle(
            color: muted,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your pets, your priority.',
          style: TextStyle(
            color: ink,
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 22),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF244D40), Color(0xFF528C73)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: mint,
                          size: 17,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'YOUR PET FAMILY',
                          style: TextStyle(
                            color: mint,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${pets.length} furry friends',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Make every moment count.',
                      style: TextStyle(
                        color: Color(0xFFDCECE3),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: addPet,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add a pet'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                          ),
                        ),
                        const Spacer(),
                        const Text('🐕 🐈', style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -45,
                right: -45,
                child: Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: statCard(
                icon: Icons.pets_rounded,
                title: 'My pets',
                value: '${pets.length}',
                subtitle: 'In your family',
                color: const Color(0xFFE1F1E8),
                onTap: () => setState(() => selectedTab = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard(
                icon: Icons.notifications_active_rounded,
                title: 'Reminders',
                value: '$pending',
                subtitle: 'Pending tasks',
                color: const Color(0xFFFFEAD5),
                onTap: () => setState(() => selectedTab = 3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 29),
        sectionHeading(
          'Your companions',
          'VIEW ALL',
          () => setState(() => selectedTab = 1),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 164,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final pet = pets[index];
              return GestureDetector(
                onTap: () => setState(() => selectedTab = 1),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: const Color(0xFFE6ECE7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pet.emoji, style: const TextStyle(fontSize: 37)),
                      const Spacer(),
                      Text(
                        pet.name,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        pet.breed,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        sectionHeading(
          "Today's care",
          'SEE ALL',
          () => setState(() => selectedTab = 3),
        ),
        const SizedBox(height: 13),
        ...reminders.take(3).map((item) => reminderTile(item)),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: () => showMessage(
            'Clinic search will be added in the next update.',
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EFE8),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on_outlined, color: ink, size: 29),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find a vet near you',
                        style: TextStyle(
                          color: ink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Discover nearby pet clinics',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: const Color(0xFFE8EDE8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 39,
              width: 39,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: ink),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w800,
                fontSize: 25,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(color: muted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeading(
    String title,
    String action,
    VoidCallback onTap,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ink,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF39866C),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget reminderTile(Map<String, dynamic> item) {
    final bool done = item['done'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8EDE8)),
      ),
      child: Row(
        children: [
          Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFFE3F2E8)
                  : const Color(0xFFFFEEDB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item['icon'] as IconData, color: ink, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: TextStyle(
                    color: ink,
                    fontWeight: FontWeight.bold,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'] as String,
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Checkbox(
            value: done,
            activeColor: const Color(0xFF39866C),
            onChanged: (value) {
              setState(() => item['done'] = value ?? false);
            },
          ),
        ],
      ),
    );
  }

  Widget buildPets() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        pageHeader('My pets', 'Your lovely companions'),
        const SizedBox(height: 20),
        ...pets.asMap().entries.map((entry) {
          final pet = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE4EBE5)),
            ),
            child: Row(
              children: [
                Container(
                  height: 76,
                  width: 76,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mint.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Text(pet.emoji, style: const TextStyle(fontSize: 39)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(pet.breed, style: const TextStyle(color: muted)),
                      const SizedBox(height: 5),
                      Text(
                        '${pet.age} ${pet.age == 1 ? 'year' : 'years'} old',
                        style: const TextStyle(
                          color: Color(0xFF39866C),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => pets.removeAt(entry.key));
                    showMessage('${pet.name} removed');
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: addPet,
          icon: const Icon(Icons.add),
          label: const Text('Add new pet'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(53),
          ),
        ),
      ],
    );
  }

  Widget buildHealth() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        pageHeader('Health tracker', 'Keep your pets healthy'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF214C3E), Color(0xFF568E75)],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.health_and_safety_rounded, color: mint, size: 35),
              SizedBox(height: 14),
              Text(
                'Healthy pets, happy hearts.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Keep vaccination records, medicines and vet visits organised.',
                style: TextStyle(color: Color(0xFFDCECE3), height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Pet health overview',
          style: TextStyle(
            color: ink,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        const SizedBox(height: 14),
        ...pets.map(
          (pet) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),
            ),
            child: Row(
              children: [
                Text(pet.emoji, style: const TextStyle(fontSize: 31)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'No health records added yet',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => showMessage(
                    'Health record form will be added next.',
                  ),
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color(0xFF39866C),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Health records are not yet saved permanently.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget buildReminders() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        pageHeader('Reminders', 'Every little thing matters'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE1F1E8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay on track',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: ink,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Keep your pet care routine organised.',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.event_available_rounded,
                size: 48,
                color: Color(0xFF39866C),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Today's tasks",
                style: TextStyle(
                  color: ink,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${reminders.where((r) => r['done'] == true).length}/${reminders.length} done',
              style: const TextStyle(
                color: Color(0xFF39866C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...reminders.map((item) => reminderTile(item)),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: addReminder,
          icon: const Icon(Icons.add),
          label: const Text('Add reminder'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(53),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Demo reminders only. Scheduled notifications will be integrated separately.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        pageHeader('Your profile', 'Manage your PetCare experience'),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: mint,
                child: Icon(Icons.person_rounded, size: 46, color: ink),
              ),
              SizedBox(height: 14),
              Text(
                'Pet parent',
                style: TextStyle(
                  color: ink,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Your pets deserve the best.',
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        profileItem(
          Icons.pets_rounded,
          'My pets',
          'Manage your companions',
          () => setState(() => selectedTab = 1),
        ),
        profileItem(
          Icons.notifications_outlined,
          'Reminders',
          'Manage care tasks',
          () => setState(() => selectedTab = 3),
        ),
        profileItem(
          Icons.location_on_outlined,
          'Nearby clinics',
          'Clinic finder coming soon',
          () => showMessage('Clinic finder is not connected yet.'),
        ),
        profileItem(
          Icons.privacy_tip_outlined,
          'Privacy',
          'Your data stays on this demo screen',
          () => showMessage('Local demo only; cloud sync is not configured.'),
        ),
        profileItem(
          Icons.info_outline_rounded,
          'About PetCare',
          'Version 1.0.0',
          () => showMessage('PetCare version 1.0.0'),
        ),
      ],
    );
  }

  Widget pageHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PETCARE',
          style: TextStyle(
            color: Color(0xFF39866C),
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          title,
          style: const TextStyle(
            color: ink,
            fontSize: 29,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: muted)),
      ],
    );
  }

  Widget profileItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE1F1E8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: ink),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: ink,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: muted),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: muted),
      onTap: onTap,
    );
  }
}

