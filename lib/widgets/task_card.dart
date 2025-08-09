import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onStartTask;
  final VoidCallback? onMarkComplete;
  final Function(DateTime)? onDateChanged;

  const TaskCard({
    super.key,
    required this.task,
    this.onStartTask,
    this.onMarkComplete,
    this.onDateChanged,
  });

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return const Color(0xFFFF6B6B); 
      case TaskStatus.started:
        return const Color(0xFFFFB84D); 
      case TaskStatus.completed:
        return const Color(0xFF4CAF50); 
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return _getOverdueText();
      case TaskStatus.started:
        return _getDueText();
      case TaskStatus.completed:
        return _getCompletedText();
    }
  }

  String _getOverdueText() {
    final now = DateTime.now();
    final difference = now.difference(task.startDate);
    
    if (difference.inDays > 0) {
      return 'Overdue - ${difference.inDays}d ${difference.inHours % 24}h ${difference.inMinutes % 60}m';
    } else if (difference.inHours > 0) {
      return 'Overdue - ${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return 'Overdue - ${difference.inMinutes}m';
    }
  }

  String _getDueText() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final isToday = task.startDate.day == DateTime.now().day;
    final isTomorrow = task.startDate.day == tomorrow.day;
    
    if (isToday) {
      return 'Due Today';
    } else if (isTomorrow) {
      return 'Due Tomorrow';
    } else {
      final difference = task.startDate.difference(DateTime.now());
      return 'Due in ${difference.inDays} days';
    }
  }

  String _getCompletedText() {
    return 'Completed: ${DateFormat('MMM dd').format(task.startDate)}';
  }

  String _getTaskPrefix() {
    switch (task.type) {
      case TaskType.order:
        return 'Order-';
      case TaskType.entity:
        return 'Entity-';
      case TaskType.enquiry:
        return 'Enquiry-';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: task.startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != task.startDate) {
      onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: _getStatusColor(),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${_getTaskPrefix()}${task.id}',
                      style: const TextStyle(
                        color: Color(0xFF6B46C1),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      ':',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (task.status == TaskStatus.notStarted || task.status == TaskStatus.started)
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            // Bottom row with assignee, priority, and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Assignee and priority - make flexible to prevent overflow
                Flexible(
                  flex: 2,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          task.assignee,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (task.isHighPriority) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'High Priority',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Action buttons and completion indicator - make flexible
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Start date with edit icon for not started tasks
                      if (task.status == TaskStatus.notStarted) ...[
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Text(
                                    'Start: ${DateFormat('MMM dd').format(task.startDate)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      // Started date for started tasks
                      if (task.status == TaskStatus.started) ...[
                        Flexible(
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Text(
                              'Start: ${DateFormat('MMM dd').format(task.startDate)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      
                      // Completed date for completed tasks
                      if (task.status == TaskStatus.completed) ...[
                        Flexible(
                          child: Text(
                            'Start: ${DateFormat('MMM dd').format(task.startDate)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      
                      const SizedBox(width: 8),
                      
                      // Action buttons
                      if (task.status == TaskStatus.notStarted) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B46C1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: onStartTask,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Start Task',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else if (task.status == TaskStatus.started) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: onMarkComplete,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Mark as complete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else if (task.status == TaskStatus.completed) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 