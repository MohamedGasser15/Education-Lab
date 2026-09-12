import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';

class FakeWishlistRepository extends WishlistRepository {
  List<WishlistItemModel> mockItems;
  bool shouldSucceed;

  FakeWishlistRepository({
    this.mockItems = const [],
    this.shouldSucceed = true,
  });

  @override
  Future<Result<List<WishlistItemModel>>> getWishlist() async {
    if (shouldSucceed) {
      return Success(mockItems);
    }
    return const Failure('Error fetching wishlist');
  }

  @override
  Future<Result<bool>> addToWishlist(int courseId) async {
    if (shouldSucceed) {
      return const Success(true);
    }
    return const Failure('Failed to add');
  }

  @override
  Future<Result<bool>> removeFromWishlist(int courseId) async {
    if (shouldSucceed) {
      mockItems.removeWhere((item) => item.courseId == courseId);
      return const Success(true);
    }
    return const Failure('Failed to remove');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WishlistProvider Logic', () {
    late WishlistProvider provider;
    late FakeWishlistRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeWishlistRepository(
        mockItems: [
          const WishlistItemModel(
            id: 1,
            courseId: 101,
            courseTitle: 'Course A',
            courseShortDescription: 'Short description A',
            coursePrice: 40.0,
            finalPrice: 40.0,
            instructorName: 'Inst A',
          ),
          const WishlistItemModel(
            id: 2,
            courseId: 202,
            courseTitle: 'Course B',
            courseShortDescription: 'Short description B',
            coursePrice: 60.0,
            finalPrice: 60.0,
            instructorName: 'Inst B',
          ),
        ],
      );
      provider = WishlistProvider(repository: fakeRepo);
    });

    test('initial state has empty items before fetch', () {
      expect(provider.items, isEmpty);
      expect(provider.count, 0);
      expect(provider.isEmpty, isTrue);
      expect(provider.isInWishlist(101), isFalse);
    });

    test('reset clears wishlist state', () {
      provider.reset();
      expect(provider.items, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });
  });
}
