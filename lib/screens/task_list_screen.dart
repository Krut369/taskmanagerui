import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<Task> tasks = [
    Task(
      id: '1043',
      title: 'Arrange Pickup',
      description: 'Arrange pickup for order',
      assignee: 'Sandhya',
      status: TaskStatus.notStarted,
      startDate: DateTime.now().subtract(const Duration(hours: 10, minutes: 5)),
      isHighPriority: true,
      type: TaskType.order,
    ),
    Task(
      id: '2559',
      title: 'Adhoc Task',
      description: 'Complete adhoc task',
      assignee: 'Arman',
      status: TaskStatus.notStarted,
      startDate: DateTime.now().subtract(const Duration(hours: 16, minutes: 4)),
      isHighPriority: false,
      type: TaskType.entity,
    ),
    Task(
      id: '1020',
      title: 'Collect Payment',
      description: 'Collect payment from customer',
      assignee: 'Sandhya',
      status: TaskStatus.notStarted,
      startDate: DateTime.now().subtract(const Duration(hours: 17, minutes: 2)),
      isHighPriority: true,
      type: TaskType.order,
    ),
    Task(
      id: '194',
      title: 'Arrange Delivery',
      description: 'Arrange delivery for order',
      assignee: 'Prashant',
      status: TaskStatus.completed,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      isHighPriority: false,
      type: TaskType.order,
    ),
    Task(
      id: '2184',
      title: 'Share Company Profile',
      description: 'Share company profile with client',
      assignee: 'Asif Khan K',
      status: TaskStatus.completed,
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      isHighPriority: false,
      type: TaskType.entity,
    ),
    Task(
      id: '472',
      title: 'Add Followup',
      description: 'Add followup for customer',
      assignee: 'Avik',
      status: TaskStatus.completed,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      isHighPriority: false,
      type: TaskType.entity,
    ),
    Task(
      id: '3563',
      title: 'Convert Enquiry',
      description: 'Convert enquiry to order',
      assignee: 'Prashant',
      status: TaskStatus.started,
      startDate: DateTime.now().add(const Duration(days: 2)),
      isHighPriority: false,
      type: TaskType.enquiry,
    ),
    Task(
      id: '176',
      title: 'Arrange Pickup',
      description: 'Arrange pickup for order',
      assignee: 'Prashant',
      status: TaskStatus.started,
      startDate: DateTime.now().add(const Duration(days: 1)),
      isHighPriority: true,
      type: TaskType.order,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> _getFilteredTasks() {
    switch (_tabController.index) {
      case 0: 
        return tasks;
      case 1: 
        return tasks.where((task) => task.status == TaskStatus.notStarted).toList();
      case 2: 
        return tasks.where((task) => task.status == TaskStatus.started).toList();
      case 3: 
        return tasks.where((task) => task.status == TaskStatus.completed).toList();
      default:
        return tasks;
    }
  }

  int _getTaskCount(TaskStatus? status) {
    if (status == null) return tasks.length;
    return tasks.where((task) => task.status == status).length;
  }

  void _startTask(int index) {
    setState(() {
      final originalIndex = tasks.indexOf(_getFilteredTasks()[index]);
      tasks[originalIndex] = tasks[originalIndex].copyWith(
        status: TaskStatus.started,
        startDate: DateTime.now(),
      );
    });
  }

  void _markTaskComplete(int index) {
    setState(() {
      final originalIndex = tasks.indexOf(_getFilteredTasks()[index]);
      tasks[originalIndex] = tasks[originalIndex].copyWith(
        status: TaskStatus.completed,
      );
    });
  }

  void _updateTaskDate(int index, DateTime newDate) {
    setState(() {
      final originalIndex = tasks.indexOf(_getFilteredTasks()[index]);
      tasks[originalIndex] = tasks[originalIndex].copyWith(
        startDate: newDate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {}),
          labelColor: const Color(0xFF6B46C1),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color(0xFF6B46C1),
          isScrollable: true,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('All'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_getTaskCount(null)}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pending'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_getTaskCount(TaskStatus.notStarted)}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Active'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB84D).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_getTaskCount(TaskStatus.started)}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFB84D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Done'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_getTaskCount(TaskStatus.completed)}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(),  
          _buildTaskList(), 
          _buildTaskList(), 
          _buildTaskList(), 
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final filteredTasks = _getFilteredTasks();
    
    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tasks matching this filter will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          task: task,
          onStartTask: task.status == TaskStatus.notStarted
              ? () => _startTask(index)
              : null,
          onMarkComplete: task.status == TaskStatus.started
              ? () => _markTaskComplete(index)
              : null,
          onDateChanged: (task.status == TaskStatus.notStarted ||
                  task.status == TaskStatus.started)
              ? (newDate) => _updateTaskDate(index, newDate)
              : null,
        );
      },
    );
  }
} 