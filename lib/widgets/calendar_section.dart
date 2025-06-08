import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/task_model.dart';
import '../widgets/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarSection extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final List<Task> tasks;
  final Function() refreshTasks;
  final String userId;

  const CalendarSection({
    super.key,
    required this.onDateSelected,
    required this.tasks,
    required this.refreshTasks,
    required this.userId,
  });

  @override
  _CalendarSectionState createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<Task> _getTasksForDay(DateTime day) {
    return widget.tasks.where((task) => isSameDay(task.date, day)).toList();
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    widget.onDateSelected(selectedDay);

    final tasks = _getTasksForDay(selectedDay);
    if (tasks.isNotEmpty) {
      _showTasksDialog(selectedDay, tasks);
    } else {
      _showAddTaskDialog(selectedDay);
    }
  }

  void _showTasksDialog(DateTime day, List<Task> tasks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tareas para ${DateFormat('dd/MM/yyyy').format(day)}',
          style: GoogleFonts.comicNeue(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: GoogleFonts.comicNeue(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.description,
                        style: GoogleFonts.comicNeue(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${task.startTime} - ${task.endTime}',
                        style: GoogleFonts.comicNeue(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 24),
                        onPressed: () => _editTask(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                        onPressed: () => _deleteTask(task),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar',
                style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddTaskDialog(day);
            },
            child: Text('Añadir Tarea',
                style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(DateTime selectedDay) {
    _titleController.clear();
    _descriptionController.clear();
    _startTime = null;
    _endTime = null;

    showDialog(
      context: context,
      builder: (context) => _buildTaskDialog(
        context: context,
        title: 'Añadir Tarea',
        selectedDay: selectedDay,
        isEditing: false,
      ),
    );
  }

  void _editTask(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _startTime = _parseTime(task.startTime);
    _endTime = _parseTime(task.endTime);

    showDialog(
      context: context,
      builder: (context) => _buildTaskDialog(
        context: context,
        title: 'Editar Tarea',
        selectedDay: task.date,
        isEditing: true,
        task: task,
      ),
    );
  }

  Widget _buildTaskDialog({
    required BuildContext context,
    required String title,
    required DateTime selectedDay,
    bool isEditing = false,
    Task? task,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(title,
              style: GoogleFonts.comicNeue(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              )),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.access_time, size: 28, color: Colors.black),
                  title: Text(
                    _startTime == null
                        ? 'Seleccionar hora inicio'
                        : 'Hora inicio: ${_startTime!.format(context)}',
                    style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => _startTime = time);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time, size: 28, color: Colors.black),
                  title: Text(
                    _endTime == null
                        ? 'Seleccionar hora fin'
                        : 'Hora fin: ${_endTime!.format(context)}',
                    style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _endTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => _endTime = time);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
                  style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _startTime != null &&
                    _endTime != null) {
                  final updatedTask = Task(
                    id: task?.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    startTime:
                    '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}',
                    endTime:
                    '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}',
                    date: selectedDay,
                    userId: widget.userId, // Añadido el userId aquí
                  );

                  if (isEditing) {
                    await DatabaseHelper.instance.updateTask(updatedTask);
                  } else {
                    await DatabaseHelper.instance.insertTask(updatedTask);
                  }

                  widget.refreshTasks();
                  Navigator.pop(context);
                }
              },
              child: Text(
                isEditing ? 'Guardar Cambios' : 'Guardar',
                style: GoogleFonts.comicNeue(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> _deleteTask(Task task) async {
    await DatabaseHelper.instance.deleteTask(task.id!);
    widget.refreshTasks();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _handleDaySelected,
        calendarFormat: CalendarFormat.month,
        daysOfWeekHeight: 40,
        rowHeight: 60,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.comicNeue(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          leftChevronIcon: Icon(Icons.chevron_left,
              color: Colors.deepPurple, size: 30),
          rightChevronIcon: Icon(Icons.chevron_right,
              color: Colors.deepPurple, size: 30),
          formatButtonTextStyle: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 8),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.comicNeue(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          weekendStyle: GoogleFonts.comicNeue(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        calendarStyle: CalendarStyle(
          todayTextStyle: GoogleFonts.comicNeue(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          selectedTextStyle: GoogleFonts.comicNeue(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          defaultTextStyle: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black),
          weekendTextStyle: GoogleFonts.comicNeue(
            color: Colors.deepPurple,
            fontSize: 16,
          ),
          outsideTextStyle: GoogleFonts.comicNeue(
            color: Colors.grey,
            fontSize: 14,
          ),
          disabledTextStyle: GoogleFonts.comicNeue(
            color: Colors.grey[300],
            fontSize: 14,
          ),
          todayDecoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          markersAlignment: Alignment.bottomCenter,
          markersAutoAligned: false,
          markerSize: 9,
          markerMargin: const EdgeInsets.symmetric(horizontal: 1),
          outsideDaysVisible: false,
          cellPadding: EdgeInsets.all(6),
          canMarkersOverflow: false,
        ),
        eventLoader: _getTasksForDay,
      ),
    );
  }
}