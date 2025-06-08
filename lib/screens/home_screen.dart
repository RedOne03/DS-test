import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/calendar_section.dart';
import '../widgets/task_model.dart';
import '../widgets/database_helper.dart';
import 'user_screen.dart';
import 'settings.dart';
import 'inspira.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui'; // Para BackdropFilter e ImageFilter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Task> _allTasks = [];
  String? _currentUserId;
  bool _isLoading = true;
  bool _hasError = false;
  final veryLightPurple = Colors.purple[50];
  final lightPurple = Colors.purple[100];
  final mediumPurple = Colors.purple[200];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _currentUserId = user.uid;
        });
        await _loadAllTasks();
      }
    } catch (e) {
      print('Error initializing user: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAllTasks() async {
    if (_currentUserId == null) return;

    try {
      final tasks = await DatabaseHelper.instance.getAllTasks(_currentUserId!);
      setState(() {
        _allTasks = tasks;
        _hasError = false;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  void _handleDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title, style: GoogleFonts.comicNeue(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description, style: GoogleFonts.comicNeue()),
            const SizedBox(height: 10),
            Text('Hora inicio: ${task.startTime}', style: GoogleFonts.comicNeue()),
            Text('Hora fin: ${task.endTime}', style: GoogleFonts.comicNeue()),
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(task.date)}', style: GoogleFonts.comicNeue()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar', style: GoogleFonts.comicNeue()),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteTask(task.id!);
              await _loadAllTasks();
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: GoogleFonts.comicNeue(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewTask() async {
    if (_currentUserId == null) return;

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva Tarea', style: GoogleFonts.comicNeue()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: GoogleFonts.comicNeue(),
                ),
                style: GoogleFonts.comicNeue(),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: GoogleFonts.comicNeue(),
                ),
                style: GoogleFonts.comicNeue(),
              ),
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora inicio (HH:MM)',
                  labelStyle: GoogleFonts.comicNeue(),
                ),
                style: GoogleFonts.comicNeue(),
              ),
              TextField(
                controller: endTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora fin (HH:MM)',
                  labelStyle: GoogleFonts.comicNeue(),
                ),
                style: GoogleFonts.comicNeue(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.comicNeue()),
          ),
          TextButton(
            onPressed: () async {
              final newTask = Task(
                title: titleController.text,
                description: descriptionController.text,
                startTime: startTimeController.text,
                endTime: endTimeController.text,
                date: _selectedDate,
                userId: _currentUserId!,
              );
              await DatabaseHelper.instance.insertTask(newTask);
              await _loadAllTasks();
              Navigator.pop(context);
            },
            child: Text('Guardar', style: GoogleFonts.comicNeue(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error al cargar los datos', style: GoogleFonts.comicNeue(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeUser,
                child: Text('Reintentar', style: GoogleFonts.comicNeue()),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentUserId == null) {
      return Scaffold(
        body: Center(
          child: Text('Usuario no autenticado', style: GoogleFonts.comicNeue()),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Image.asset(
              'assets/images/renace.png',
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ),
        backgroundColor: CupertinoColors.lightBackgroundGray.withOpacity(0.7),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 30, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: CalendarSection(
                    onDateSelected: _handleDateSelected,
                    tasks: _allTasks,
                    refreshTasks: _loadAllTasks,
                    userId: _currentUserId!,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder<List<Task>>(
                    future: DatabaseHelper.instance.getTasksByDate(_selectedDate, _currentUserId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final tasks = snapshot.data ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Tareas para ${DateFormat('dd/MM/yyyy').format(_selectedDate)}:',
                            style: GoogleFonts.comicNeue(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...tasks.map((task) => GestureDetector(
                            onTap: () => _showTaskDetails(context, task),
                            child: Card(
                              color: veryLightPurple,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  task.title,
                                  style: GoogleFonts.comicNeue(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.description, style: GoogleFonts.comicNeue()),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16, color: Colors.black),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${task.startTime} - ${task.endTime}',
                                          style: GoogleFonts.comicNeue(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          if (tasks.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  'No hay tareas para este día',
                                  style: GoogleFonts.comicNeue(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black54,
              currentIndex: 0,
              selectedLabelStyle: GoogleFonts.comicNeue(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.comicNeue(
                fontSize: 16,
              ),
              iconSize: 35,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const InspiraScreen(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const UserScreen(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Inicio",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb_outline),
                  label: "Inspirar",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: "Perfil",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}