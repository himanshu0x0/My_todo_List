import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytodoapp/features/task_management/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_repository.g.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addTask({required Task task, required String userId}) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());
    await docRef.update({'id': docRef.id});
  }

  Future<void> updateTask({
    required Task task,
    required String taskId,
    required String userId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update(task.toMap());
  }

  Stream<List<Task>> loadTasks(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot) => QuerySnapshot.docs
              .map((doc) => Task.fromMap(doc.data()))
              .toList(),
        );
  }

  Stream<List<Task>> loadCompletedTasks(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('isComplete', isEqualTo: true)
        .snapshots()
        .map(
          (QuerySnapshot) => QuerySnapshot.docs
              .map((doc) => Task.fromMap(doc.data()))
              .toList(),
        );
  }

  Stream<List<Task>> loadInCompletedTasks(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('isComplete', isEqualTo: false)
        .snapshots()
        .map(
          (QuerySnapshot) => QuerySnapshot.docs
              .map((doc) => Task.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> updateTaskCompletion({
    required String userId,
    required String taskId,
    required bool isComplete,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({'isComplete': isComplete});
  }
}

@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(FirestoreRepositoryRef ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Task>> loadTasks(LoadTasksRef ref, {required String userId}) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadTasks(userId);
}

@riverpod
Stream<List<Task>> loadCompleteTasks(LoadCompleteTasksRef ref, {required String userId}) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadCompletedTasks(userId); // <-- Corrected
}



@riverpod
Stream<List<Task>> loadInCompleteTasks(LoadInCompleteTasksRef ref, {required String userId}) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadInCompletedTasks(userId); // Corrected
}

