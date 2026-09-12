import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:mobile/features/wishlist/data/services/wishlist_api_service.dart';

class FakeWishlistApiService extends WishlistApiService {
  List<WishlistItemModel> items = [
    const WishlistItemModel(
      id: 1,
      courseId: 101,
      courseTitle: 'Flutter Course',
      courseShortDescription: 'Learn Flutter',
      coursePrice: 90,
      finalPrice: 90,
      instructorName: 'Mohamed',
    ),
  ];

  @override
  Future<Result<List<WishlistItemModel>>> getWishlist() async {
    return Success(items);
  }

  @override
  Future<Result<bool>> addToWishlist(int courseId) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> removeFromWishlist(int courseId) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> isCourseInWishlist(int courseId) async {
    return Success(items.any((i) => i.courseId == courseId));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WishlistRepository Tests', () {
    late WishlistRepository repository;
    late FakeWishlistApiService fakeService;

    setUp(() {
      fakeService = FakeWishlistApiService();
      repository = WishlistRepository(service: fakeService);
    });

    test('getWishlist returns list of items', () async {
      final res = await repository.getWishlist();
      expect(res is Success<List<WishlistItemModel>>, isTrue);
      expect((res as Success<List<WishlistItemModel>>).data.length, 1);
    });

    test('isCourseInWishlist checks course presence', () async {
      final inWishlist = await repository.isCourseInWishlist(101);
      expect((inWishlist as Success<bool>).data, isTrue);

      final notInWishlist = await repository.isCourseInWishlist(999);
      expect((notInWishlist as Success<bool>).data, isFalse);
    });

    test('addToWishlist and removeFromWishlist delegate to service', () async {
      final addRes = await repository.addToWishlist(102);
      expect((addRes as Success<bool>).data, isTrue);

      final removeRes = await repository.removeFromWishlist(101);
      expect((removeRes as Success<bool>).data, isTrue);
    });
  });
}
