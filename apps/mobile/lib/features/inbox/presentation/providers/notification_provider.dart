import 'package:flutter/material.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/inbox/data/models/notification_model.dart';
import 'package:mobile/features/inbox/data/models/notification_summary_model.dart';
import 'package:mobile/features/inbox/data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationProvider({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository();

  List<NotificationModel> _notifications = [];
  NotificationSummaryModel? _summary;
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedFilterIndex = 0; // 0: All, 1: Courses, 2: Promos, 3: System

  List<NotificationModel> get notifications => _notifications;
  NotificationSummaryModel? get summary => _summary;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedFilterIndex => _selectedFilterIndex;
  bool get isEmpty => _notifications.isEmpty;

  List<NotificationModel> get filteredNotifications {
    switch (_selectedFilterIndex) {
      case 1:
        return _notifications.where((n) => n.type == 2 || n.type == 3).toList();
      case 2:
        return _notifications.where((n) => n.type == 1).toList();
      case 3:
        return _notifications.where((n) => n.type == 0 || n.type == 4).toList();
      case 0:
      default:
        return _notifications;
    }
  }

  void setFilterIndex(int index) {
    if (_selectedFilterIndex != index) {
      _selectedFilterIndex = index;
      notifyListeners();
    }
  }

  Future<void> fetchNotifications({bool forceRefresh = false}) async {
    final isLoggedIn = await AuthStorageService.isLoggedIn();
    if (!isLoggedIn) {
      _notifications = [];
      _summary = null;
      _unreadCount = 0;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    if (_notifications.isEmpty || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final results = await Future.wait([
      _repository.getNotifications(pageNumber: 1, pageSize: 50),
      _repository.getUnreadCount(),
    ]);

    final notifResult = results[0] as Result<List<NotificationModel>>;
    final countResult = results[1] as Result<int>;

    if (notifResult is Success<List<NotificationModel>>) {
      _notifications = notifResult.data;
      _errorMessage = null;
    } else if (notifResult is Failure<List<NotificationModel>>) {
      _errorMessage = notifResult.message;
    }

    if (countResult is Success<int>) {
      _unreadCount = countResult.data;
    } else {
      // Calculate local unread count if count endpoint failed
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUnreadCount() async {
    final result = await _repository.getUnreadCount();
    if (result is Success<int>) {
      _unreadCount = result.data;
      notifyListeners();
    }
  }

  Future<bool> markAllAsRead() async {
    if (_unreadCount == 0 && _notifications.every((n) => n.isRead)) {
      return true;
    }

    final previousNotifications = List<NotificationModel>.from(_notifications);
    final previousUnreadCount = _unreadCount;

    // Optimistic update
    _notifications = _notifications.map((n) {
      return n.copyWith(status: 1, readAt: DateTime.now());
    }).toList();
    _unreadCount = 0;
    notifyListeners();

    final result = await _repository.markAllAsRead();
    if (result is Success<bool>) {
      return true;
    } else if (result is Failure<bool>) {
      _notifications = previousNotifications;
      _unreadCount = previousUnreadCount;
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> markAsRead(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return true;

    final target = _notifications[index];
    final wasUnread = !target.isRead;

    // Optimistic update
    _notifications[index] = target.copyWith(status: 1, readAt: DateTime.now());
    if (wasUnread && _unreadCount > 0) {
      _unreadCount--;
    }
    notifyListeners();

    final result = await _repository.markAsRead(id);
    if (result is Success<bool>) {
      return true;
    } else if (result is Failure<bool>) {
      _notifications[index] = target;
      if (wasUnread) {
        _unreadCount++;
      }
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> deleteNotification(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return false;

    final deletedItem = _notifications[index];
    final wasUnread = !deletedItem.isRead;

    // Optimistic update
    _notifications.removeAt(index);
    if (wasUnread && _unreadCount > 0) {
      _unreadCount--;
    }
    notifyListeners();

    final result = await _repository.deleteNotification(id);
    if (result is Success<bool>) {
      return true;
    } else if (result is Failure<bool>) {
      _notifications.insert(index, deletedItem);
      if (wasUnread) {
        _unreadCount++;
      }
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> deleteAllNotifications() async {
    if (_notifications.isEmpty) return true;

    final previousNotifications = List<NotificationModel>.from(_notifications);
    final previousUnreadCount = _unreadCount;

    // Optimistic update
    _notifications = [];
    _unreadCount = 0;
    notifyListeners();

    final result = await _repository.deleteAllNotifications();
    if (result is Success<bool>) {
      return true;
    } else if (result is Failure<bool>) {
      _notifications = previousNotifications;
      _unreadCount = previousUnreadCount;
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  void reset() {
    _notifications = [];
    _summary = null;
    _unreadCount = 0;
    _isLoading = false;
    _errorMessage = null;
    _selectedFilterIndex = 0;
    notifyListeners();
  }
}
