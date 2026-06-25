import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Notifier class to manage the active bottom navigation tab index
class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

// NotifierProvider to expose the navigation state
final navigationProvider = NotifierProvider<NavigationNotifier, int>(NavigationNotifier.new);

// StreamProvider to monitor the Firebase Auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
