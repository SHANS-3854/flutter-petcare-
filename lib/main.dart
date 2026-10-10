
import 'package:flutter/material.dart';

void main() => runApp(const PetCareApp());

const ink = Color(0xFF19372E);
const green = Color(0xFF397D63);
const mint = Color(0xFFDDF2E5);
const background = Color(0xFFF6F8F4);
const muted = Color(0xFF7A8981);

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
      ),
      home: const PetCareHome(),
    );
  }
}

class Pet {
  String name;
  String breed;
  String emoji;
  int age;

  Pet(this.name, this.breed, this.emoji, this.age);
}

class CareTask {
  String title;
  String pet;
  String time;
  bool done;

  CareTask(this.title, this.pet, this.time, {this.done = false});
}

class PetCareHome extends StatefulWidget {
  const PetCareHome({super.key});

  @override
  State<PetCareHome> createState() => _PetCareHomeState();
}

class _PetCareHomeState extends State<PetCareHome> {
  int tab = 0;

  final pets = <Pet>[
    Pet('Bruno', 'Golden Retriever', '🐕', 2),
    Pet('Milo', 'Persian Cat', '🐈', 1),
  ];

  final tasks = <CareTask>[
    CareTask('Morning feeding', 'Bruno', '8:00 AM'),
    CareTask('Vaccination check', 'Milo', '4:30 PM'),
    CareTask('Evening walk', 'Bruno', '6:00 PM', done: true),
  ];

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void addPet() {
    final name = TextEditingController();
    final breed = TextEditingController();
    final age = TextEditingController(text: '1');
    String emoji = '🐕';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: const Text('Add your pet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12,
                  children: ['🐕', '🐈', '🐇', '🐦', '🐹'].map((e) {
                    return InkWell(
                      onTap: () => refresh(() => emoji = e),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: emoji == e ? mint : background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 27)),
                      ),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Pet name'),
                ),
                TextField(
                  controller: breed,
                  decoration: const InputDecoration(labelText: 'Breed'),
                ),
                TextField(
                  controller: age,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age in years'),
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
                if (name.text.trim().isEmpty) return;
                setState(() {
                  pets.add(
                    Pet(
                      name.text.trim(),
                      breed.text.trim().isEmpty ? 'Pet' : breed.text.trim(),
                      emoji,
                      int.tryParse(age.text) ?? 1,
                    ),
                  );
                });
                Navigator.pop(dialogContext);
                message('Pet added successfully');
              },
              child: const Text('Add pet'),
            ),
          ],
        ),
      ),
    );
  }

  void addTask() {
    final title = TextEditingController();
    final pet = TextEditingController(
      text: pets.isNotEmpty ? pets.first.name : '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: 'Reminder title',
                hintText: 'Give medicine',
              ),
            ),
            TextField(
              controller: pet,
              decoration: const InputDecoration(labelText: 'Pet name'),
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
              if (title.text.trim().isEmpty) return;
              setState(() {
                tasks.add(CareTask(title.text.trim(), pet.text.trim(), 'Today'));
              });
              Navigator.pop(dialogContext);
              message('Reminder added');
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
      homePage(),
      petsPage(),
      healthPage(),
      remindersPage(),
      profilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: tab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: tab,
        backgroundColor: Colors.white,
        indicatorColor: mint,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets_rounded),
            label: 'My Pets',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    final pending = tasks.where((t) => !t.done).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(21, 18, 21, 30),
      children: [
        Row(
          children: [
            Container(
              height: 47,
              width: 47,
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.pets, color: ink, size: 27),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PETCARE',
                    style: TextStyle(
                      color: ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
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
              onPressed: () => setState(() => tab = 4),
              icon: const Icon(Icons.person_outline),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Text('GOOD DAY!', style: TextStyle(color: muted, fontSize: 13)),
        const SizedBox(height: 5),
        const Text(
          'Your pets, your priority.',
          style: TextStyle(
            color: ink,
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 21),
        Container(
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF204B3B), Color(0xFF599579)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite, color: mint, size: 17),
                  SizedBox(width: 7),
                  Text(
                    'YOUR PET FAMILY',
                    style: TextStyle(
                      color: mint,
                      fontSize: 11,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.bold,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Make every moment count.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 19),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: addPet,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add a pet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white60),
                    ),
                  ),
                  const Spacer(),
                  const Text('🐕 🐈', style: TextStyle(fontSize: 29)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: statCard(
                'My pets',
                '${pets.length}',
                'Your companions',
                Icons.pets,
                const Color(0xFFE2F1E7),
                () => setState(() => tab = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard(
                'Reminders',
                '$pending',
                'Tasks pending',
                Icons.notifications_active_outlined,
                const Color(0xFFFFEBD7),
                () => setState(() => tab = 3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 27),
        sectionTitle(
          'Your companions',
          'VIEW ALL',
          () => setState(() => tab = 1),
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 155,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final p = pets[i];
              return Container(
                width: 148,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),
                  border: Border.all(color: const Color(0xFFE7ECE7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.emoji, style: const TextStyle(fontSize: 37)),
                    const Spacer(),
                    Text(
                      p.name,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      p.breed,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 25),
        sectionTitle(
          "Today's care",
          'SEE ALL',
          () => setState(() => tab = 3),
        ),
        const SizedBox(height: 10),
        ...tasks.take(3).map(taskTile),
        const SizedBox(height: 12),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: mint,
          leading: const Icon(Icons.location_on_outlined, color: ink, size: 29),
          title: const Text(
            'Find a vet near you',
            style: TextStyle(fontWeight: FontWeight.bold, color: ink),
          ),
          subtitle: const Text(
            'Nearby clinic finder coming soon',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => message('Clinic search will be added next.'),
        ),
      ],
    );
  }

  Widget statCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7ECE7)),
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
            const SizedBox(height: 12),
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

  Widget sectionTitle(String title, String action, VoidCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: green,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget taskTile(CareTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE7ECE7)),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: task.done ? mint : const Color(0xFFFFEBD7),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              task.done ? Icons.check_circle_outline : Icons.pets,
              color: ink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: ink,
                    fontWeight: FontWeight.bold,
                    decoration: task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.pet} · ${task.time}',
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Checkbox(
            value: task.done,
            activeColor: green,
            onChanged: (v) => setState(() => task.done = v ?? false),
          ),
        ],
      ),
    );
  }

  Widget header(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PETCARE',
          style: TextStyle(
            color: green,
            fontSize: 12,
            fontWeight: FontWeight.w900,
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
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: muted)),
      ],
    );
  }

  Widget petsPage() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        header('My pets', 'Your lovely companions'),
        const SizedBox(height: 23),
        ...pets.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 13),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: const Color(0xFFE7ECE7)),
            ),
            child: Row(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(p.emoji, style: const TextStyle(fontSize: 37)),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(p.breed, style: const TextStyle(color: muted)),
                      Text(
                        '${p.age} years old',
                        style: const TextStyle(color: green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => pets.removeAt(i));
                    message('Pet removed');
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
            minimumSize: const Size.fromHeight(52),
          ),
        ),
      ],
    );
  }

  Widget healthPage() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        header('Health tracker', 'A healthy pet is a happy pet'),
        const SizedBox(height: 23),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF204B3B), Color(0xFF599579)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.health_and_safety, color: mint, size: 37),
              SizedBox(height: 15),
              Text(
                'Their health matters.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Keep track of vaccination, medicines and vet visits in one place.',
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Health overview',
          style: TextStyle(
            color: ink,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13),
        ...pets.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(p.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'No health records added',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => message('Health records feature coming next.'),
                  icon: const Icon(Icons.add_circle_outline, color: green),
                ),
              ],
            ),
          ),
        ),
        const Text(
          'Health records are not saved permanently in this version.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget remindersPage() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        header('Reminders', 'Every little thing matters'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: mint,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay on track',
                      style: TextStyle(
                        color: ink,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Organise your daily pet care.',
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.event_available, color: green, size: 44),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
              '${tasks.where((t) => t.done).length}/${tasks.length} done',
              style: const TextStyle(
                color: green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        ...tasks.map(taskTile),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: addTask,
          icon: const Icon(Icons.add),
          label: const Text('Add reminder'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'These are demo reminders. Scheduled notifications are not enabled yet.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        header('Your profile', 'Your PetCare experience'),
        const SizedBox(height: 23),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 41,
                backgroundColor: mint,
                child: Icon(Icons.person, size: 46, color: ink),
              ),
              SizedBox(height: 13),
              Text(
                'Pet parent',
                style: TextStyle(
                  color: ink,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
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
        const SizedBox(height: 20),
        profileRow(
          Icons.pets,
          'My pets',
          'Manage your companions',
          () => setState(() => tab = 1),
        ),
        profileRow(
          Icons.notifications_outlined,
          'Reminders',
          'Manage care tasks',
          () => setState(() => tab = 3),
        ),
        profileRow(
          Icons.location_on_outlined,
          'Nearby clinics',
          'Coming soon',
          () => message('Clinic finder coming soon'),
        ),
        profileRow(
          Icons.privacy_tip_outlined,
          'Privacy',
          'Demo version',
          () => message('Cloud sync is not configured yet'),
        ),
        profileRow(
          Icons.info_outline,
          'About PetCare',
          'Version 1.0.0',
          () => message('PetCare version 1.0.0'),
        ),
      ],
    );
  }

  Widget profileRow(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      leading: Container(
        height: 43,
        width: 43,
        decoration: BoxDecoration(
          color: mint,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: ink),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: ink,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: muted, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: muted),
      onTap: onTap,
    );
  }
}
