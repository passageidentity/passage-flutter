import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'mailosaur_api_client.g.dart'; // Ensure this path is correct

@JsonSerializable()
class NameEmail {
  final String name;
  final String email;

  NameEmail({required this.name, required this.email});

  factory NameEmail.fromJson(Map<String, dynamic> json) =>
      _$NameEmailFromJson(json);
  Map<String, dynamic> toJson() => _$NameEmailToJson(this);
}

@JsonSerializable()
class MessageLink {
  final String href;
  final String text;

  MessageLink({required this.href, required this.text});

  factory MessageLink.fromJson(Map<String, dynamic> json) =>
      _$MessageLinkFromJson(json);
  Map<String, dynamic> toJson() => _$MessageLinkToJson(this);
}

@JsonSerializable()
class MessageCode {
  final String value;

  MessageCode({required this.value});

  factory MessageCode.fromJson(Map<String, dynamic> json) =>
      _$MessageCodeFromJson(json);
  Map<String, dynamic> toJson() => _$MessageCodeToJson(this);
}

@JsonSerializable()
class MessageHTML {
  final String body;
  final List<MessageLink> links;
  final List<MessageCode> codes;

  MessageHTML({required this.body, required this.links, required this.codes});

  factory MessageHTML.fromJson(Map<String, dynamic> json) =>
      _$MessageHTMLFromJson(json);
  Map<String, dynamic> toJson() => _$MessageHTMLToJson(this);
}

@JsonSerializable()
class ListMessage {
  final String id;
  final String received;
  final String type;
  final String subject;
  final List<NameEmail> from;
  final List<NameEmail> to;
  final List<String> cc;
  final List<String> bcc;

  ListMessage(
      {required this.id,
      required this.received,
      required this.type,
      required this.subject,
      required this.from,
      required this.to,
      required this.cc,
      required this.bcc});

  factory ListMessage.fromJson(Map<String, dynamic> json) =>
      _$ListMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ListMessageToJson(this);
}

@JsonSerializable()
class ListMessagesResponse {
  final List<ListMessage> items;

  ListMessagesResponse({required this.items});

  factory ListMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$ListMessagesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListMessagesResponseToJson(this);
}

@JsonSerializable()
class GetMessageResponse {
  final String id;
  final String received;
  final String type;
  final String subject;
  final List<NameEmail> from;
  final List<NameEmail> to;
  final List<String> cc;
  final List<String> bcc;
  final MessageHTML html;

  GetMessageResponse(
      {required this.id,
      required this.received,
      required this.type,
      required this.subject,
      required this.from,
      required this.to,
      required this.cc,
      required this.bcc,
      required this.html});

  factory GetMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetMessageResponseToJson(this);
}

class MailosaurAPIClient {
  static const String serverId = 'ncor7c1m';
  static const String apiURL = 'https://mailosaur.com/api/messages';
  static const String mailosaurAPIKey = 'udoOEVY0FNE11tTh';

  static String appUrl(String path) {
    if (kIsWeb) {
      return 'http://localhost:3000/api/messages$path';
    }
    return '$apiURL$path';
  }

  static String get authHeader {
    final apiKey = 'api:$mailosaurAPIKey';
    final encodedApiKey = base64Encode(utf8.encode(apiKey));
    return 'Basic $encodedApiKey';
  }

  static Future<http.Request> buildRequest(String url) async {
    try {
      final parsedUrl = Uri.parse(url);
      return http.Request('GET', parsedUrl)
        ..headers['Authorization'] = authHeader;
    } catch (e) {
      throw Exception('Bad url path');
    }
  }

  static Future<String> getMostRecentMagicLink() async {
    try {
      final messages = await listMessages();
      if (messages.isEmpty) return '';
      final message = await getMessage(messages[0].id);
      final incomingURL = message.html.links[0].href;
      final components = Uri.parse(incomingURL).queryParameters;
      final magicLink = components['psg_magic_link'];
      return magicLink ?? '';
    } catch (e) {
      return '';
    }
  }

  static Future<String> getMostRecentOneTimePasscode() async {
    try {
      final messages = await listMessages();
      if (messages.isEmpty) return '';
      messages.sort((a, b) => b.received.compareTo(a.received));
      final message = await getMessage(messages[0].id);
      final oneTimePasscode = message.html.codes.first.value;
      return oneTimePasscode;
    } catch (e) {
      return '';
    }
  }

  static Future<GetMessageResponse> getMessage(String id) async {
    final url = appUrl('/$id');
    final request = await buildRequest(url);
    final response =
        await http.Response.fromStream(await http.Client().send(request));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return GetMessageResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load message');
    }
  }

  static Future<List<ListMessage>> listMessages() async {
    final url = appUrl('?server=$serverId');
    final request = await buildRequest(url);
    final response =
        await http.Response.fromStream(await http.Client().send(request));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ListMessagesResponse.fromJson(jsonResponse).items;
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
