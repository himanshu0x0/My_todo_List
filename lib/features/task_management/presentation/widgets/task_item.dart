import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mytodoapp/features/authentication/data/auth_repository.dart';
import 'package:mytodoapp/features/task_management/data/firestore_repository.dart';
import 'package:mytodoapp/features/task_management/domain/task.dart';
import 'package:mytodoapp/features/task_management/presentation/firestore_controller.dart';
import 'package:mytodoapp/utils/appstyles.dart';
import 'package:mytodoapp/utils/size_config.dart';

String formattedDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('dd-mm-yyyy').format(dateTime);
  return formattedDate;
}

class TaskItem extends ConsumerStatefulWidget {
  const TaskItem(this.task, {super.key});
  final Task task;

  @override
  ConsumerState createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  void _deleteTask(String taskId) {
    final userId = ref.watch(currentUserProvider)!.uid;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure', style: AppStyle.titleTextStyle),
        icon: Icon(Icons.delete, size: 60, color: Colors.red),
        alignment: Alignment.center,
        content: const Text('Tap to delete the task!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Cancel', style: AppStyle.normalTextStyle),
          ),

          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(firestoreControllerProvider.notifier)
                  .deleteTask(userId: userId, taskId: taskId);
            },
            child: Text('Delete', style: AppStyle.normalTextStyle),
          ),
        ],
      ),
    );
  }

void _updateTask() {
  TextEditingController titleController =
      TextEditingController(text: widget.task.title);
  TextEditingController descriptionController =
      TextEditingController(text: widget.task.description);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.edit, color: Colors.green, size: 40),
      title: Text('Update Task', style: AppStyle.normalTextStyle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => context.pop(),
          child: Text('Cancel', style: AppStyle.normalTextStyle),
        ),
        ElevatedButton(
          onPressed: () async {
            String newTitle = titleController.text.trim();
            String newDesc = descriptionController.text.trim();

            if (newTitle.isEmpty || newDesc.isEmpty) {
              // Optional: show error if empty
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Title or Description cannot be empty')),
              );
              return;
            }

            final userId = ref.read(currentUserProvider)!.uid;

            final updatedTask = Task(
              id: widget.task.id,
              title: newTitle,
              description: newDesc,
              priority: widget.task.priority,
              isComplete: widget.task.isComplete,
              date: DateTime.now().toString(),
            );

            // Await update to make sure it's completed before closing
            await ref
                .read(firestoreControllerProvider.notifier)
                .updateTask(
                  task: updatedTask,
                  userId: userId,
                  taskId: widget.task.id,
                );

            context.pop(); // Close the dialog after updating
          },
          child: Text('Update', style: AppStyle.normalTextStyle),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: AppStyle.headingTextStyle.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                Text(
                  widget.task.description,
                  style: AppStyle.normalTextStyle.copyWith(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(20)),

                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      height: SizeConfig.getProportionateHeight(40),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.task.priority.toUpperCase(),
                        style: AppStyle.normalTextStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionatewidth(10)),

                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      height: SizeConfig.getProportionateHeight(40),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            formattedDate(widget.task.date),
                            style: AppStyle.normalTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.scale(
                  scale: 1.8,
                  child: Checkbox(
                    value: widget.task.isComplete,
                    onChanged: (bool? value) {
                      if (value == null) {
                        return;
                      } else {
                        final userId = ref.watch(currentUserProvider)!.uid;
                        ref
                            .read(firestoreRepositoryProvider)
                            .updateTaskCompletion(
                              userId: userId,
                              taskId: widget.task.id,
                              isComplete: value,
                            );
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: _updateTask,
                  child: Container(
                    height: SizeConfig.getProportionateHeight(40),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    _deleteTask(widget.task.id);
                  },
                  child: Container(
                    height: SizeConfig.getProportionateHeight(40),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
