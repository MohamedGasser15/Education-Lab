import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';
import 'package:mobile/features/learning/data/models/lecture_comment_model.dart';
import 'package:mobile/features/learning/data/services/course_learning_api_service.dart';

class CourseLearningRepository {
  final CourseLearningApiService _apiService;

  CourseLearningRepository({CourseLearningApiService? apiService})
      : _apiService = apiService ?? CourseLearningApiService();

  Future<Result<CourseDetailsModel>> getCourseDetails(int courseId) =>
      _apiService.getCourseDetails(courseId);

  Future<Result<CourseProgressSummaryModel>> getCourseProgress(int courseId) =>
      _apiService.getCourseProgress(courseId);

  Future<Result<Map<int, bool>>> getLectureStatuses(int courseId) =>
      _apiService.getLectureStatuses(courseId);

  Future<Result<bool>> markLectureCompleted(int courseId, int lectureId) =>
      _apiService.markLectureCompleted(courseId, lectureId);

  Future<Result<bool>> markLectureIncomplete(int courseId, int lectureId) =>
      _apiService.markLectureIncomplete(courseId, lectureId);

  Future<Result<List<LectureResourceModel>>> getLectureResources(int lectureId) =>
      _apiService.getLectureResources(lectureId);

  Future<Result<List<LectureCommentModel>>> getLectureComments(int lectureId) =>
      _apiService.getLectureComments(lectureId);

  Future<Result<LectureCommentModel>> addComment(int lectureId, String content) =>
      _apiService.addComment(lectureId, content);

  Future<Result<LectureCommentModel>> replyToComment(int commentId, String content) =>
      _apiService.replyToComment(commentId, content);

  Future<Result<bool>> deleteComment(int commentId) =>
      _apiService.deleteComment(commentId);

  Future<Result<bool>> canUserRate(int courseId) =>
      _apiService.canUserRate(courseId);

  Future<Result<CourseRatingModel?>> getMyRating(int courseId) =>
      _apiService.getMyRating(courseId);

  Future<Result<List<CourseRatingModel>>> getCourseRatings(int courseId, {int page = 1, int pageSize = 30}) =>
      _apiService.getCourseRatings(courseId, page: page, pageSize: pageSize);

  Future<Result<CourseRatingSummaryModel>> getCourseRatingSummary(int courseId) =>
      _apiService.getCourseRatingSummary(courseId);

  Future<Result<CourseRatingModel>> addRating(int courseId, int rating, String review) =>
      _apiService.addRating(courseId, rating, review);

  Future<Result<CourseRatingModel>> updateRating(int ratingId, int rating, String review) =>
      _apiService.updateRating(ratingId, rating, review);

  Future<Result<bool>> deleteRating(int ratingId) =>
      _apiService.deleteRating(ratingId);

  Future<Result<CertificateModel?>> getCourseCertificate(int courseId) =>
      _apiService.getCourseCertificate(courseId);
}
