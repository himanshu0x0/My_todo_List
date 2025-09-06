import 'package:mytodoapp/features/task_management/data/firestore_repository.dart';
import 'package:mytodoapp/features/task_management/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_controller.g.dart';

@riverpod
class FirestoreController extends _$FirestoreController {
  @override
  FutureOr<void> build() async {
    // You can initialize some async state here if needed.
    // For now, just return null.
    return;
  }

  Future<void> addTask({required Task task, required String userId}) async {
    state = const AsyncLoading();
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    state = await AsyncValue.guard(
      () => firestoreRepository.addTask(task: task, userId: userId),
    );
  }

  Future<void> updateTask({
    required Task task,
    required String userId,
    required String taskId,
  }) async {
    state = const AsyncLoading();
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    state = await AsyncValue.guard(
      () => firestoreRepository.updateTask(
        task: task,
        taskId: taskId,
        userId: userId,
      ),
    );
  }

  Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    state = const AsyncLoading();
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    state = await AsyncValue.guard(
      () => firestoreRepository.deleteTask(userId: userId, taskId: taskId),
    );
  }
}
