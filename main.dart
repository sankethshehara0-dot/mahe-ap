import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaheApp());
const purple = Color(0xFF8F7CF7);

class MaheApp extends StatefulWidget {
  const MaheApp({super.key});
  @override State<MaheApp> createState() => _MaheAppState();
}
class _MaheAppState extends State<MaheApp> {
  bool dark = false;
  @override void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => dark = p.getBool('dark') ?? false);
    });
  }
  Future<void> setDark(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark', v);
    if (mounted) setState(() => dark = v);
  }
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Mahe', debugShowCheckedModeBanner: false,
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: purple)),
    darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark)),
    home: MaheHome(dark: dark, onDark: setDark),
  );
}
class MaheHome extends StatefulWidget {
  final bool dark; final ValueChanged<bool> onDark;
  const MaheHome({super.key, required this.dark, required this.onDark});
  @override State<MaheHome> createState() => _MaheHomeState();
}
class _MaheHomeState extends State<MaheHome> {
  int tab = 0;
  final titles = ['Home', 'Messages', 'Reels', 'Friends', 'Profile', 'Settings'];
  @override Widget build(BuildContext context) {
    final pages = [
      const HomePage(), const MessagesPage(), const ReelsPage(), const FriendsPage(),
      const ProfilePage(), SettingsPage(dark: widget.dark, onDark: widget.onDark),
    ];
    return Scaffold(
      appBar: AppBar(title: Row(children: [
        const MaheMark(size: 34), const SizedBox(width: 9),
        Text('Mahe • ${titles[tab]}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ]), actions: [
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoPage(title: 'Online Map', message: 'Map preview placeholder. Add a map provider API key to enable a live map. Location sharing should always be optional.'))), icon: const Icon(Icons.map_outlined)),
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoPage(title: 'Random Chat', message: 'Random matching is not connected in this starter. Add age-appropriate access controls, reporting, blocking and moderation before enabling stranger chat.'))), icon: const Icon(Icons.video_chat_outlined)),
      ]),
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Message'),
          NavigationDestination(icon: Icon(Icons.play_circle_outline), label: 'Reels'),
          NavigationDestination(icon: Icon(Icons.people_outline), label: 'Friends'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ]),
    );
  }
}
class MaheMark extends StatelessWidget {
  final double size; const MaheMark({super.key, this.size = 60});
  @override Widget build(BuildContext context) => Container(width: size, height: size,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(size * .25),
      gradient: const LinearGradient(colors: [Color(0xFFBFB4FF), Color(0xFF7765E8)])),
    child: Icon(Icons.people_alt_rounded, color: Colors.white, size: size * .58));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFE9E4FF), Color(0xFFC9C0FF)]),
      borderRadius: BorderRadius.circular(22)), child: const Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Your world, together.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF342768))),
          SizedBox(height: 6), Text('Share moments with friends.', style: TextStyle(color: Color(0xFF514583))),
        ])), MaheMark(size: 55),
      ])),
    const SizedBox(height: 18), const Text('Stories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    const SizedBox(height: 10), const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Story(name: 'Your story', icon: Icons.add), Story(name: 'Nethmi', icon: Icons.person),
      Story(name: 'Kavindu', icon: Icons.person), Story(name: 'Amaya', icon: Icons.person),
    ]),
    const SizedBox(height: 12),
    const PostCard(name: 'Nethmi Perera', caption: 'A little sunshine makes every day better ☀️', icon: Icons.landscape, color: Color(0xFFB9D9D2)),
    const PostCard(name: 'Kavindu Silva', caption: 'Weekend memories with my favourite people ✨', icon: Icons.directions_bike, color: Color(0xFFD9C9F8)),
    const Text('Sample feed only. Online posts need a backend.', style: TextStyle(color: Colors.grey, fontSize: 12)),
  ]);
}
class Story extends StatelessWidget {
  final String name; final IconData icon;
  const Story({super.key, required this.name, required this.icon});
  @override Widget build(BuildContext context) => Column(children: [
    CircleAvatar(radius: 27, backgroundColor: purple, child: Icon(icon, color: Colors.white)),
    const SizedBox(height: 4), Text(name, style: const TextStyle(fontSize: 11)),
  ]);
}
class PostCard extends StatelessWidget {
  final String name, caption; final IconData icon; final Color color;
  const PostCard({super.key, required this.name, required this.caption, required this.icon, required this.color});
  @override Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, margin: const EdgeInsets.only(bottom: 14),
    child: Column(children: [
      ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(name), subtitle: const Text('Friend')),
      Container(height: 170, width: double.infinity, color: color, child: Icon(icon, size: 72, color: Colors.white)),
      ListTile(leading: const Icon(Icons.favorite_border), title: Text(caption), trailing: const Icon(Icons.share_outlined)),
    ]));
}
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override Widget build(BuildContext context) => ListView(children: [
    for (final n in ['Nethmi Perera', 'Kavindu Silva', 'Amaya Fernando'])
      ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(n),
        subtitle: const Text('Tap to open demo chat'), onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ChatPage(name: n)))),
  ]);
}
class ChatPage extends StatefulWidget {
  final String name; const ChatPage({super.key, required this.name});
  @override State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  final input = TextEditingController(); final messages = <String>['Hi! How are you?'];
  @override void dispose() { input.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(widget.name)),
    body: Column(children: [
      Expanded(child: ListView(children: [
        for (final m in messages) ListTile(title: Align(alignment: Alignment.centerRight, child: Text(m))),
        const Text('Demo only: messages are not sent to other users.', textAlign: TextAlign.center),
      ])),
      SafeArea(child: Row(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(8), child: TextField(controller: input, decoration: const InputDecoration(hintText: 'Message')))),
        IconButton(icon: const Icon(Icons.send), onPressed: () { if (input.text.trim().isNotEmpty) setState(() { messages.add(input.text.trim()); input.clear(); }); }),
      ])),
    ]));
}
class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});
  @override Widget build(BuildContext context) => PageView(scrollDirection: Axis.vertical, children: const [
    Reel(color: Color(0xFFB9D9D2), title: 'Moments that matter'),
    Reel(color: Color(0xFFD9C9F8), title: 'Make today count'),
    Reel(color: Color(0xFFF3D8C6), title: 'Good vibes only'),
  ]);
}
class Reel extends StatelessWidget {
  final Color color; final String title; const Reel({super.key, required this.color, required this.title});
  @override Widget build(BuildContext context) => Container(color: color, child: Stack(children: [
    const Center(child: Icon(Icons.play_circle_fill, size: 100, color: Colors.white)),
    Positioned(left: 20, bottom: 30, child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF342768)))),
  ]));
}
class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});
  @override Widget build(BuildContext context) => ListView(children: [
    const Padding(padding: EdgeInsets.all(16), child: Text('Friend requests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    for (final n in ['Sahan Perera', 'Dinuli Fernando', 'Ravindu Silva'])
      ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(n),
        trailing: FilledButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$n accepted in demo only'))), child: const Text('Accept'))),
  ]);
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  final picker = ImagePicker(); final name = TextEditingController(text: 'Your Name');
  final bio = TextEditingController(text: 'Welcome to my Mahe profile 💜'); XFile? photo;
  Future<void> pick() async { final f = await picker.pickImage(source: ImageSource.gallery); if (f != null) setState(() => photo = f); }
  @override void dispose() { name.dispose(); bio.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    Center(child: Column(children: [
      GestureDetector(onTap: pick, child: CircleAvatar(radius: 45, backgroundImage: photo == null ? null : FileImage(File(photo!.path)),
        child: photo == null ? const Icon(Icons.add_a_photo_outlined) : null)),
      TextField(controller: name, textAlign: TextAlign.center, decoration: const InputDecoration(labelText: 'Display name')),
      TextField(controller: bio, textAlign: TextAlign.center, decoration: const InputDecoration(labelText: 'Personal details')),
      const SizedBox(height: 10), FilledButton.icon(onPressed: pick, icon: const Icon(Icons.add_photo_alternate), label: const Text('Choose profile photo')),
      const SizedBox(height: 18), const Text('Shared posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const Text('Phone numbers and email addresses are not shown on this profile.', style: TextStyle(color: Colors.grey, fontSize: 12)),
    ])),
  ]);
}
class SettingsPage extends StatelessWidget {
  final bool dark; final ValueChanged<bool> onDark;
  const SettingsPage({super.key, required this.dark, required this.onDark});
  @override Widget build(BuildContext context) => ListView(children: [
    SwitchListTile(title: const Text('Dark mode'), secondary: const Icon(Icons.dark_mode_outlined), value: dark, onChanged: onDark),
    const ListTile(leading: Icon(Icons.lock_outline), title: Text('Account & privacy')),
    const ListTile(leading: Icon(Icons.visibility_off_outlined), title: Text('Hide contact details')),
    const ListTile(leading: Icon(Icons.notifications_outlined), title: Text('Notifications')),
    const ListTile(leading: Icon(Icons.security_outlined), title: Text('Security and blocked accounts')),
    const ListTile(leading: Icon(Icons.language_outlined), title: Text('Language and region')),
    const ListTile(leading: Icon(Icons.help_outline), title: Text('Help and support')),
    const Padding(padding: EdgeInsets.all(16), child: Text('Demo settings. Real accounts require a secure backend.', style: TextStyle(color: Colors.grey, fontSize: 12))),
  ]);
}
class InfoPage extends StatelessWidget {
  final String title, message; const InfoPage({super.key, required this.title, required this.message});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Padding(padding: const EdgeInsets.all(24), child: Text(message)));
}
