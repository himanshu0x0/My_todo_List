import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytodoapp/common_widgets/async_value_ui.dart';
import 'package:mytodoapp/common_widgets/async_value_widget.dart';
import 'package:mytodoapp/features/authentication/data/auth_repository.dart';
import 'package:mytodoapp/features/task_management/data/firestore_repository.dart';
import 'package:mytodoapp/features/task_management/domain/task.dart';
import 'package:mytodoapp/features/task_management/presentation/widgets/task_item.dart';
import 'package:mytodoapp/utils/appstyles.dart';

class IncompleteTasksScreen extends ConsumerStatefulWidget {
  const IncompleteTasksScreen({super.key});

  @override
  ConsumerState createState() => _IncompleteTasksScreenState();
}

class _IncompleteTasksScreenState extends ConsumerState<IncompleteTasksScreen> {
  @override
  Widget build(BuildContext context) {
  final userId = ref.watch(currentUserProvider)!.uid;
  final inCompleteTasksAsyncValue =
      ref.watch(loadInCompleteTasksProvider(userId: userId));

  ref.listen<AsyncValue>(loadInCompleteTasksProvider(userId: userId), (_, state) {
    state.showAlertDialogOnError(context);
  });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incomplete tasks',
          style: AppStyle.titleTextStyle.copyWith(color: Colors.white),
        ),
      ),
      body: AsyncValueWidget<List<Task>>(
        value: inCompleteTasksAsyncValue,
        data: (tasks) {
          return tasks.isEmpty
              ? const Center(child: Text('No Tasks yet...'))
              : ListView.separated(
                  itemBuilder: (ctx, index) {
                    final task = tasks[index];
                    return TaskItem(task);
                  },
                  separatorBuilder: (ctx, height) =>
                      const Divider(height: 2, color: Colors.blue),
                  itemCount: tasks.length,
                );
        },
      ),
    );
  }
}
