// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailosaur_api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NameEmail _$NameEmailFromJson(Map<String, dynamic> json) => NameEmail(
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$NameEmailToJson(NameEmail instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
    };

MessageLink _$MessageLinkFromJson(Map<String, dynamic> json) => MessageLink(
      href: json['href'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$MessageLinkToJson(MessageLink instance) =>
    <String, dynamic>{
      'href': instance.href,
      'text': instance.text,
    };

MessageCode _$MessageCodeFromJson(Map<String, dynamic> json) => MessageCode(
      value: json['value'] as String,
    );

Map<String, dynamic> _$MessageCodeToJson(MessageCode instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

MessageHTML _$MessageHTMLFromJson(Map<String, dynamic> json) => MessageHTML(
      body: json['body'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => MessageLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      codes: (json['codes'] as List<dynamic>)
          .map((e) => MessageCode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageHTMLToJson(MessageHTML instance) =>
    <String, dynamic>{
      'body': instance.body,
      'links': instance.links,
      'codes': instance.codes,
    };

ListMessage _$ListMessageFromJson(Map<String, dynamic> json) => ListMessage(
      id: json['id'] as String,
      received: json['received'] as String,
      type: json['type'] as String,
      subject: json['subject'] as String,
      from: (json['from'] as List<dynamic>)
          .map((e) => NameEmail.fromJson(e as Map<String, dynamic>))
          .toList(),
      to: (json['to'] as List<dynamic>)
          .map((e) => NameEmail.fromJson(e as Map<String, dynamic>))
          .toList(),
      cc: (json['cc'] as List<dynamic>).map((e) => e as String).toList(),
      bcc: (json['bcc'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ListMessageToJson(ListMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'received': instance.received,
      'type': instance.type,
      'subject': instance.subject,
      'from': instance.from,
      'to': instance.to,
      'cc': instance.cc,
      'bcc': instance.bcc,
    };

ListMessagesResponse _$ListMessagesResponseFromJson(
        Map<String, dynamic> json) =>
    ListMessagesResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => ListMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListMessagesResponseToJson(
        ListMessagesResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) =>
    GetMessageResponse(
      id: json['id'] as String,
      received: json['received'] as String,
      type: json['type'] as String,
      subject: json['subject'] as String,
      from: (json['from'] as List<dynamic>)
          .map((e) => NameEmail.fromJson(e as Map<String, dynamic>))
          .toList(),
      to: (json['to'] as List<dynamic>)
          .map((e) => NameEmail.fromJson(e as Map<String, dynamic>))
          .toList(),
      cc: (json['cc'] as List<dynamic>).map((e) => e as String).toList(),
      bcc: (json['bcc'] as List<dynamic>).map((e) => e as String).toList(),
      html: MessageHTML.fromJson(json['html'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetMessageResponseToJson(GetMessageResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'received': instance.received,
      'type': instance.type,
      'subject': instance.subject,
      'from': instance.from,
      'to': instance.to,
      'cc': instance.cc,
      'bcc': instance.bcc,
      'html': instance.html,
    };
