import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';

void main() {
  group('SupportConversationModel', () {
    test('fromJson parses support conversation details correctly', () {
      final json = {
        'id': 12,
        'subject': 'Billing issue with Visa card',
        'status': 'Open',
        'unreadCount': 2,
        'lastMessage': 'We are looking into this.',
      };

      final convo = SupportConversationModel.fromJson(json);

      expect(convo.id, 12);
      expect(convo.subject, 'Billing issue with Visa card');
      expect(convo.isOpen, isTrue);
      expect(convo.unreadCount, 2);
      expect(convo.lastMessage, 'We are looking into this.');
    });

    test('toJson produces valid json map', () {
      final convo = SupportConversationModel(
        id: 1,
        subject: 'General Question',
        status: 'Closed',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
      );

      final json = convo.toJson();

      expect(json['id'], 1);
      expect(json['subject'], 'General Question');
      expect(json['status'], 'Closed');
    });
  });

  group('SupportMessageModel', () {
    test('fromJson parses message sender and flags', () {
      final json = {
        'id': 50,
        'conversationId': 12,
        'senderId': 'agent-1',
        'senderRole': 'Support',
        'content': 'Your refund has been processed.',
        'isRead': true,
      };

      final msg = SupportMessageModel.fromJson(json);

      expect(msg.id, 50);
      expect(msg.conversationId, 12);
      expect(msg.senderRole, 'Support');
      expect(msg.content, 'Your refund has been processed.');
      expect(msg.isUser, isFalse);
      expect(msg.isRead, isTrue);
    });
  });
}
