import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';
import 'package:mobile/features/learning/data/models/lecture_comment_model.dart';
import 'package:mobile/features/learning/data/repositories/course_learning_repository.dart';

class CourseLearningProvider extends ChangeNotifier {
  final CourseLearningRepository _repository;

  CourseLearningProvider({CourseLearningRepository? repository})
    : _repository = repository ?? resolveOr(() => CourseLearningRepository());

  // State flags
  bool _isLoading = false;
  bool _isLoadingComments = false;
  bool _isLoadingRatings = false;
  bool _isSubmittingComment = false;
  bool _isSubmittingRating = false;
  String? _errorMessage;

  // Course & Curriculum
  CourseDetailsModel? _course;
  CourseProgressSummaryModel? _progressSummary;
  Map<int, bool> _lectureStatuses = {};

  // Active indices
  int _currentSectionIndex = 0;
  int _currentLectureIndex = 0;

  // Active Lecture Data & Course Feedback
  List<LectureCommentModel> _comments = [];
  List<LectureResourceModel> _resources = [];
  List<CourseRatingModel> _courseRatings = [];
  CourseRatingSummaryModel? _ratingSummary;
  CertificateModel? _certificate;
  CourseRatingModel? _myRating;
  bool _canRate = false;

  // Local Notes (timestamp -> text)
  final Map<int, List<Map<String, String>>> _lectureNotes = {};

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingComments => _isLoadingComments;
  bool get isLoadingRatings => _isLoadingRatings;
  bool get isSubmittingComment => _isSubmittingComment;
  bool get isSubmittingRating => _isSubmittingRating;
  String? get errorMessage => _errorMessage;

  CourseDetailsModel? get course => _course;
  CourseProgressSummaryModel? get progressSummary => _progressSummary;
  Map<int, bool> get lectureStatuses => _lectureStatuses;

  int get currentSectionIndex => _currentSectionIndex;
  int get currentLectureIndex => _currentLectureIndex;

  List<LectureCommentModel> get comments => _comments;
  List<LectureResourceModel> get resources => _resources;
  List<CourseRatingModel> get courseRatings => _courseRatings;
  CourseRatingSummaryModel? get ratingSummary => _ratingSummary;
  CertificateModel? get certificate => _certificate;
  CourseRatingModel? get myRating => _myRating;
  bool get canRate => _canRate;

  bool get hasPreviousLesson {
    if (_course == null || _course!.sections.isEmpty) return false;
    return _currentLectureIndex > 0 || _currentSectionIndex > 0;
  }

  bool get hasNextLesson {
    if (_course == null || _course!.sections.isEmpty) return false;
    if (_currentSectionIndex < 0 ||
        _currentSectionIndex >= _course!.sections.length) {
      return false;
    }
    final currentSec = _course!.sections[_currentSectionIndex];
    return _currentLectureIndex < currentSec.lectures.length - 1 ||
        _currentSectionIndex < _course!.sections.length - 1;
  }

  CourseLectureModel? get currentLecture {
    if (_course == null || _course!.sections.isEmpty) return null;
    if (_currentSectionIndex < 0 ||
        _currentSectionIndex >= _course!.sections.length) {
      return null;
    }
    final section = _course!.sections[_currentSectionIndex];
    if (section.lectures.isEmpty) return null;
    if (_currentLectureIndex < 0 ||
        _currentLectureIndex >= section.lectures.length) {
      return section.lectures.first;
    }
    return section.lectures[_currentLectureIndex];
  }

  bool isLectureCompleted(int lectureId) {
    return _lectureStatuses[lectureId] == true;
  }

  List<Map<String, String>> get currentNotes {
    final lecture = currentLecture;
    if (lecture == null) return [];
    return _lectureNotes[lecture.id] ?? [];
  }

  int get totalLecturesCount {
    if (_progressSummary != null && _progressSummary!.totalLectures > 0) {
      return _progressSummary!.totalLectures;
    }
    if (_course != null) {
      return _course!.calculatedTotalLectures;
    }
    return 0;
  }

  int get completedLecturesCount {
    if (_progressSummary != null && _progressSummary!.completedLectures > 0) {
      return _progressSummary!.completedLectures;
    }
    return _lectureStatuses.values.where((status) => status == true).length;
  }

  int get progressPercentage {
    if (_progressSummary != null && _progressSummary!.progressPercentage > 0) {
      return _progressSummary!.progressPercentage.round();
    }
    final total = totalLecturesCount;
    if (total == 0) return 0;
    final completed = completedLecturesCount;
    return ((completed / total) * 100).round().clamp(0, 100);
  }

  /// 1. Initialize & load all course data
  Future<void> loadCourse(int courseId, {int? initialLectureId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Fetch Course details, Progress, Lecture Statuses in parallel
      final results = await Future.wait([
        _repository.getCourseDetails(courseId),
        _repository.getCourseProgress(courseId),
        _repository.getLectureStatuses(courseId),
        _repository.getMyRating(courseId),
        _repository.canUserRate(courseId),
        _repository.getCourseCertificate(courseId),
        _repository.getCourseRatings(courseId),
        _repository.getCourseRatingSummary(courseId),
      ]);

      final courseRes = results[0] as Result<CourseDetailsModel>;
      final progressRes = results[1] as Result<CourseProgressSummaryModel>;
      final statusesRes = results[2] as Result<Map<int, bool>>;
      final ratingRes = results[3] as Result<CourseRatingModel?>;
      final canRateRes = results[4] as Result<bool>;
      final certRes = results[5] as Result<CertificateModel?>;
      final allRatingsRes = results[6] as Result<List<CourseRatingModel>>;
      final summaryRes = results[7] as Result<CourseRatingSummaryModel>;

      if (courseRes is Success<CourseDetailsModel>) {
        _course = courseRes.data;
      }

      if (progressRes is Success<CourseProgressSummaryModel>) {
        _progressSummary = progressRes.data;
      }

      if (statusesRes is Success<Map<int, bool>>) {
        _lectureStatuses = Map<int, bool>.from(statusesRes.data);
      }

      if (ratingRes is Success<CourseRatingModel?>) {
        _myRating = ratingRes.data;
      }

      if (canRateRes is Success<bool>) {
        _canRate = canRateRes.data;
      }

      if (certRes is Success<CertificateModel?>) {
        _certificate = certRes.data;
      }

      if (allRatingsRes is Success<List<CourseRatingModel>>) {
        _courseRatings = allRatingsRes.data;
      }

      if (summaryRes is Success<CourseRatingSummaryModel> &&
          summaryRes.data.totalRatings > 0 &&
          (summaryRes.data.fiveStarCount +
                  summaryRes.data.fourStarCount +
                  summaryRes.data.threeStarCount +
                  summaryRes.data.twoStarCount +
                  summaryRes.data.oneStarCount >
              0)) {
        _ratingSummary = summaryRes.data;
      } else {
        _ratingSummary = CourseRatingSummaryModel.fromRatingsList(
          _courseRatings,
          fallbackAvg: _course?.averageRating,
          fallbackTotal: _course?.totalRatings,
        );
      }

      // 2. Determine initial lecture
      _locateInitialLecture(initialLectureId);

      _isLoading = false;
      notifyListeners();

      // 3. Load active lecture data (comments, resources)
      if (currentLecture != null) {
        _fetchActiveLectureDetails(currentLecture!.id);
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'حدث خطأ أثناء تحميل الدورة: $e';
      notifyListeners();
    }
  }

  void _locateInitialLecture(int? targetLectureId) {
    if (_course == null || _course!.sections.isEmpty) return;

    if (targetLectureId != null && targetLectureId > 0) {
      for (int s = 0; s < _course!.sections.length; s++) {
        final sec = _course!.sections[s];
        for (int l = 0; l < sec.lectures.length; l++) {
          if (sec.lectures[l].id == targetLectureId) {
            _currentSectionIndex = s;
            _currentLectureIndex = l;
            return;
          }
        }
      }
    }

    // Default: find first incomplete lecture
    for (int s = 0; s < _course!.sections.length; s++) {
      final sec = _course!.sections[s];
      for (int l = 0; l < sec.lectures.length; l++) {
        final lec = sec.lectures[l];
        if (_lectureStatuses[lec.id] != true) {
          _currentSectionIndex = s;
          _currentLectureIndex = l;
          return;
        }
      }
    }

    _currentSectionIndex = 0;
    _currentLectureIndex = 0;
  }

  /// 2. Select a specific lecture
  void selectLecture(int sectionIdx, int lectureIdx) {
    if (_course == null) return;
    if (sectionIdx < 0 || sectionIdx >= _course!.sections.length) return;
    if (lectureIdx < 0 ||
        lectureIdx >= _course!.sections[sectionIdx].lectures.length) {
      return;
    }

    _currentSectionIndex = sectionIdx;
    _currentLectureIndex = lectureIdx;
    notifyListeners();

    if (currentLecture != null) {
      _fetchActiveLectureDetails(currentLecture!.id);
    }
  }

  Future<void> _fetchActiveLectureDetails(int lectureId) async {
    _isLoadingComments = true;
    _resources = currentLecture?.resources ?? [];
    notifyListeners();

    final commentsRes = await _repository.getLectureComments(lectureId);
    if (commentsRes is Success<List<LectureCommentModel>>) {
      _comments = commentsRes.data;
    } else {
      _comments = [];
    }

    _isLoadingComments = false;
    notifyListeners();
  }

  /// 3. Toggle Lecture Completion (Synced with API & Optimistic)
  Future<bool> toggleLectureCompletion(
    int lectureId, {
    required int courseId,
  }) async {
    final bool currentStatus = _lectureStatuses[lectureId] == true;
    final bool newStatus = !currentStatus;

    // Optimistic UI update
    _lectureStatuses[lectureId] = newStatus;

    // Update completed count in summary
    final updatedCompleted = _lectureStatuses.values.where((s) => s).length;
    final total = totalLecturesCount > 0 ? totalLecturesCount : 1;
    final double updatedPercentage = ((updatedCompleted / total) * 100).clamp(
      0.0,
      100.0,
    );

    _progressSummary = CourseProgressSummaryModel(
      enrollmentId: _progressSummary?.enrollmentId ?? 0,
      courseId: courseId,
      courseTitle: _course?.title ?? '',
      totalLectures: total,
      completedLectures: updatedCompleted,
      progressPercentage: updatedPercentage,
      lastActivity: DateTime.now(),
    );
    notifyListeners();

    // Call API
    final Result<bool> result = newStatus
        ? await _repository.markLectureCompleted(courseId, lectureId)
        : await _repository.markLectureIncomplete(courseId, lectureId);

    if (result is Success<bool>) {
      // Refresh progress & certificate check in background if 100% completed
      if (updatedPercentage >= 100) {
        _repository.getCourseCertificate(courseId).then((certRes) {
          if (certRes is Success<CertificateModel?> && certRes.data != null) {
            _certificate = certRes.data;
            notifyListeners();
          }
        });
      }
      return true;
    } else {
      // Revert on failure
      _lectureStatuses[lectureId] = currentStatus;
      notifyListeners();
      return false;
    }
  }

  /// 4. Go to Next / Previous Lesson
  bool playNextLesson() {
    if (_course == null || _course!.sections.isEmpty) return false;
    final currentSec = _course!.sections[_currentSectionIndex];

    if (_currentLectureIndex < currentSec.lectures.length - 1) {
      selectLecture(_currentSectionIndex, _currentLectureIndex + 1);
      return true;
    } else if (_currentSectionIndex < _course!.sections.length - 1) {
      selectLecture(_currentSectionIndex + 1, 0);
      return true;
    }
    return false; // Reached the end
  }

  bool playPreviousLesson() {
    if (_course == null || _course!.sections.isEmpty) return false;

    if (_currentLectureIndex > 0) {
      selectLecture(_currentSectionIndex, _currentLectureIndex - 1);
      return true;
    } else if (_currentSectionIndex > 0) {
      final prevSec = _currentSectionIndex - 1;
      final prevSecLectures = _course!.sections[prevSec].lectures;
      selectLecture(
        prevSec,
        prevSecLectures.isNotEmpty ? prevSecLectures.length - 1 : 0,
      );
      return true;
    }
    return false; // Reached the beginning
  }

  /// 5. Q&A / Comments
  Future<bool> addComment(String content) async {
    final lecture = currentLecture;
    if (lecture == null || content.trim().isEmpty) return false;

    _isSubmittingComment = true;
    notifyListeners();

    final result = await _repository.addComment(lecture.id, content.trim());
    _isSubmittingComment = false;

    if (result is Success<LectureCommentModel>) {
      _comments.insert(0, result.data);
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<bool> replyToComment(int commentId, String content) async {
    if (content.trim().isEmpty) return false;

    _isSubmittingComment = true;
    notifyListeners();

    final result = await _repository.replyToComment(commentId, content.trim());
    _isSubmittingComment = false;

    if (result is Success<LectureCommentModel>) {
      // Find comment and add reply
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final currentComment = _comments[index];
        final updatedReplies = List<LectureCommentModel>.from(
          currentComment.replies,
        )..add(result.data);
        _comments[index] = LectureCommentModel(
          id: currentComment.id,
          lectureId: currentComment.lectureId,
          userId: currentComment.userId,
          userName: currentComment.userName,
          userProfileImage: currentComment.userProfileImage,
          content: currentComment.content,
          parentCommentId: currentComment.parentCommentId,
          createdAt: currentComment.createdAt,
          updatedAt: currentComment.updatedAt,
          timeAgo: currentComment.timeAgo,
          isInstructorReply: currentComment.isInstructorReply,
          replies: updatedReplies,
        );
      }
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<bool> deleteComment(int commentId) async {
    final result = await _repository.deleteComment(commentId);
    if (result is Success<bool>) {
      _comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 6. Notes
  void addNote(String time, String text) {
    final lecture = currentLecture;
    if (lecture == null || text.trim().isEmpty) return;

    final list = _lectureNotes[lecture.id] ?? [];
    list.insert(0, {'time': time, 'text': text.trim()});
    _lectureNotes[lecture.id] = list;
    notifyListeners();
  }

  /// 7. Course Rating
  Future<void> loadCourseRatings() async {
    if (_course == null) return;
    _isLoadingRatings = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getCourseRatings(_course!.id),
        _repository.getCourseRatingSummary(_course!.id),
        _repository.getMyRating(_course!.id),
        _repository.canUserRate(_course!.id),
      ]);

      final allRatingsRes = results[0] as Result<List<CourseRatingModel>>;
      final summaryRes = results[1] as Result<CourseRatingSummaryModel>;
      final ratingRes = results[2] as Result<CourseRatingModel?>;
      final canRateRes = results[3] as Result<bool>;

      if (allRatingsRes is Success<List<CourseRatingModel>>) {
        _courseRatings = allRatingsRes.data;
      }
      if (summaryRes is Success<CourseRatingSummaryModel> &&
          summaryRes.data.totalRatings > 0 &&
          (summaryRes.data.fiveStarCount +
                  summaryRes.data.fourStarCount +
                  summaryRes.data.threeStarCount +
                  summaryRes.data.twoStarCount +
                  summaryRes.data.oneStarCount >
              0)) {
        _ratingSummary = summaryRes.data;
      } else {
        _ratingSummary = CourseRatingSummaryModel.fromRatingsList(
          _courseRatings,
          fallbackAvg: _course?.averageRating,
          fallbackTotal: _course?.totalRatings,
        );
      }
      if (ratingRes is Success<CourseRatingModel?>) {
        _myRating = ratingRes.data;
      }
      if (canRateRes is Success<bool>) {
        _canRate = canRateRes.data;
      }
    } catch (_) {}

    _isLoadingRatings = false;
    notifyListeners();
  }

  Future<bool> submitRating(int stars, String review) async {
    if (_course == null) return false;

    _isSubmittingRating = true;
    notifyListeners();

    final Result<CourseRatingModel> result;
    if (_myRating != null && _myRating!.id > 0) {
      result = await _repository.updateRating(_myRating!.id, stars, review);
    } else {
      result = await _repository.addRating(_course!.id, stars, review);
    }

    _isSubmittingRating = false;

    if (result is Success<CourseRatingModel>) {
      _myRating = result.data;
      await loadCourseRatings();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<bool> deleteRating() async {
    if (_myRating == null || _myRating!.id <= 0) return false;

    final ratingId = _myRating!.id;
    final result = await _repository.deleteRating(ratingId);
    if (result is Success<bool>) {
      _myRating = null;
      await loadCourseRatings();
      return true;
    }
    return false;
  }
}
