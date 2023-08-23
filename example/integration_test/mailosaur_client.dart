import 'dart:convert';
import 'package:http/http.dart' as http;

import './../../config.dart';

class URLError implements Exception {
  final String reason;
  URLError(this.reason);
}

class ListMessagesResponse {
  List<ListMessage> items;

  ListMessagesResponse({required this.items});

  factory ListMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ListMessagesResponse(
      items:
          (json['items'] as List).map((e) => ListMessage.fromJson(e)).toList(),
    );
  }
}

class ListMessage {
  String id;
  String received;
  String type;
  String subject;
  List<NameEmail> from;
  List<NameEmail> to;
  List<String> cc;
  List<String> bcc;

  ListMessage({
    required this.id,
    required this.received,
    required this.type,
    required this.subject,
    required this.from,
    required this.to,
    required this.cc,
    required this.bcc,
  });

  factory ListMessage.fromJson(Map<String, dynamic> json) {
    return ListMessage(
      id: json['id'],
      received: json['received'],
      type: json['type'],
      subject: json['subject'],
      from: (json['from'] as List).map((e) => NameEmail.fromJson(e)).toList(),
      to: (json['to'] as List).map((e) => NameEmail.fromJson(e)).toList(),
      cc: List<String>.from(json['cc']),
      bcc: List<String>.from(json['bcc']),
    );
  }
}

class NameEmail {
  String name;
  String email;

  NameEmail({required this.name, required this.email});

  factory NameEmail.fromJson(Map<String, dynamic> json) {
    return NameEmail(
      name: json['name'],
      email: json['email'],
    );
  }
}

class GetMessageResponse extends ListMessage {
  MessageHTML html;

  GetMessageResponse({
    required String id,
    required String received,
    required String type,
    required String subject,
    required List<NameEmail> from,
    required List<NameEmail> to,
    required List<String> cc,
    required List<String> bcc,
    required this.html,
  }) : super(
            id: id,
            received: received,
            type: type,
            subject: subject,
            from: from,
            to: to,
            cc: cc,
            bcc: bcc);

  factory GetMessageResponse.fromJson(Map<String, dynamic> json) {
    return GetMessageResponse(
      id: json['id'],
      received: json['received'],
      type: json['type'],
      subject: json['subject'],
      from: (json['from'] as List).map((e) => NameEmail.fromJson(e)).toList(),
      to: (json['to'] as List).map((e) => NameEmail.fromJson(e)).toList(),
      cc: List<String>.from(json['cc']),
      bcc: List<String>.from(json['bcc']),
      html: MessageHTML.fromJson(json['html']),
    );
  }
}

class MessageHTML {
  String body;
  List<MessageLink> links;
  List<MessageCode> codes;

  MessageHTML({required this.body, required this.links, required this.codes});

  factory MessageHTML.fromJson(Map<String, dynamic> json) {
    return MessageHTML(
      body: json['body'],
      links:
          (json['links'] as List).map((e) => MessageLink.fromJson(e)).toList(),
      codes:
          (json['codes'] as List).map((e) => MessageCode.fromJson(e)).toList(),
    );
  }
}

class MessageLink {
  String href;
  String text;

  MessageLink({required this.href, required this.text});

  factory MessageLink.fromJson(Map<String, dynamic> json) {
    return MessageLink(
      href: json['href'],
      text: json['text'],
    );
  }
}

class MessageCode {
  String value;

  MessageCode({required this.value});

  factory MessageCode.fromJson(Map<String, dynamic> json) {
    return MessageCode(value: json['value']);
  }
}

class MailosaurAPIClient {
  static const serverId = 'ncor7c1m';
  final String apiURL = 'https://mailosaur.com/api/messages';

  String get authHeader {
    final apiKey = base64Encode(utf8.encode('api:$mailosaurAPIKey'));
    return 'Basic: $apiKey';
  }

  Future<String> getMostRecentMagicLink() async {
    try {
      final messages = await listMessages();
      if (messages.isEmpty) return '';
      final message = await getMessage(id: messages[0].id);
      final incomingURL = message.html.links[0].href;
      final uri = Uri.parse(incomingURL);
      final magicLink = uri.queryParameters['psg_magic_link'] ?? '';
      return magicLink;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String> getMostRecentOneTimePasscode() async {
    try {
      final messages = await listMessages();
      if (messages.isEmpty) return '';
      final message = await getMessage(id: messages[0].id);
      return message.html.codes.isEmpty ? '' : message.html.codes[0].value;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<GetMessageResponse> getMessage({required String id}) async {
    final url = Uri.parse('$apiURL/$id');
    final response =
        await http.get(url, headers: {'Authorization': authHeader});
    if (response.statusCode == 200) {
      return GetMessageResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

  Future<List<ListMessage>> listMessages() async {
    final url = Uri.parse('$apiURL?server=$serverId');
    final response =
        await http.get(url, headers: {'Authorization': authHeader});
    if (response.statusCode == 200) {
      return ListMessagesResponse.fromJson(jsonDecode(response.body)).items;
    } else {
      throw Exception('Failed to list messages');
    }
  }
}
