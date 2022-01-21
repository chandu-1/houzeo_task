import 'dart:convert';

class ContactModel {
  final String imgUrl;
  final String firstName;
  final TitleLabel phone;
  final TitleLabel? altPhone;
  final bool isFavorite;
  final String uid;
  final String id;
  String? lastName;
  TitleLabel? email;
  TitleLabel? atlEmail;
  TitleLabel? address;
  TitleLabel? atlAddress;
  String? website;
  TitleLabel? relationShip;
  String? notes;
  ContactModel({
    required this.imgUrl,
    required this.firstName,
    required this.phone,
    this.altPhone,
    required this.isFavorite,
    required this.uid,
    required this.id,
    this.lastName,
    this.email,
    this.atlEmail,
    this.address,
    this.atlAddress,
    this.website,
    this.relationShip,
    this.notes,
  });

  ContactModel copyWith({
    String? imgUrl,
    String? firstName,
    TitleLabel? phone,
    TitleLabel? altPhone,
    bool? isFavorite,
    String? uid,
    String? id,
    String? lastName,
    TitleLabel? email,
    TitleLabel? atlEmail,
    TitleLabel? address,
    TitleLabel? atlAddress,
    String? website,
    TitleLabel? relationShip,
    String? notes,
  }) {
    return ContactModel(
      imgUrl: imgUrl ?? this.imgUrl,
      firstName: firstName ?? this.firstName,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      isFavorite: isFavorite ?? this.isFavorite,
      uid: uid ?? this.uid,
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      atlEmail: atlEmail ?? this.atlEmail,
      address: address ?? this.address,
      atlAddress: atlAddress ?? this.atlAddress,
      website: website ?? this.website,
      relationShip: relationShip ?? this.relationShip,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'firstName': firstName,
      'phone': phone.toMap(),
      'altPhone': altPhone?.toMap(),
      'isFavorite': isFavorite,
      'uid': uid,
      'id': id,
      'lastName': lastName,
      'email': email?.toMap(),
      'atlEmail': atlEmail?.toMap(),
      'address': address?.toMap(),
      'atlAddress': atlAddress?.toMap(),
      'website': website,
      'relationShip': relationShip?.toMap(),
      'notes': notes,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      imgUrl: map['imgUrl'] ?? '',
      firstName: map['firstName'] ?? '',
      phone: TitleLabel.fromMap(map['phone']),
      altPhone: map['altPhone'] != null ? TitleLabel.fromMap(map['altPhone']) : null,
      isFavorite: map['isFavorite'] ?? false,
      uid: map['uid'] ?? '',
      id: map['id'] ?? '',
      lastName: map['lastName'],
      email: map['email'] != null ? TitleLabel.fromMap(map['email']) : null,
      atlEmail: map['atlEmail'] != null ? TitleLabel.fromMap(map['atlEmail']) : null,
      address: map['address'] != null ? TitleLabel.fromMap(map['address']) : null,
      atlAddress: map['atlAddress'] != null ? TitleLabel.fromMap(map['atlAddress']) : null,
      website: map['website'],
      relationShip: map['relationShip'] != null ? TitleLabel.fromMap(map['relationShip']) : null,
      notes: map['notes'],
    );
  }

  factory ContactModel.empty() {
    return ContactModel(
      imgUrl: "",
      firstName: "",
      isFavorite: false,
      phone: TitleLabel.empty(),
      uid: "",
      id: "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactModel(imgUrl: $imgUrl, firstName: $firstName, phone: $phone, altPhone: $altPhone, isFavorite: $isFavorite, uid: $uid, id: $id, lastName: $lastName, email: $email, atlEmail: $atlEmail, address: $address, atlAddress: $atlAddress, website: $website, relationShip: $relationShip, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ContactModel &&
      other.imgUrl == imgUrl &&
      other.firstName == firstName &&
      other.phone == phone &&
      other.altPhone == altPhone &&
      other.isFavorite == isFavorite &&
      other.uid == uid &&
      other.id == id &&
      other.lastName == lastName &&
      other.email == email &&
      other.atlEmail == atlEmail &&
      other.address == address &&
      other.atlAddress == atlAddress &&
      other.website == website &&
      other.relationShip == relationShip &&
      other.notes == notes;
  }

  @override
  int get hashCode {
    return imgUrl.hashCode ^
      firstName.hashCode ^
      phone.hashCode ^
      altPhone.hashCode ^
      isFavorite.hashCode ^
      uid.hashCode ^
      id.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      atlEmail.hashCode ^
      address.hashCode ^
      atlAddress.hashCode ^
      website.hashCode ^
      relationShip.hashCode ^
      notes.hashCode;
  }
}

class TitleLabel {
  final String title;
  final String label;
  TitleLabel({
    required this.title,
    required this.label,
  });

  TitleLabel copyWith({
    String? title,
    String? label,
  }) {
    return TitleLabel(
      title: title ?? this.title,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'label': label,
    };
  }

  factory TitleLabel.fromMap(Map<String, dynamic> map) {
    return TitleLabel(
      title: map['title'] ?? '',
      label: map['label'] ?? '',
    );
  }
  factory TitleLabel.empty() {
    return TitleLabel(
      title: "",
      label: "",
    );
  }

  String toJson() => json.encode(toMap());

  factory TitleLabel.fromJson(String source) =>
      TitleLabel.fromMap(json.decode(source));

  @override
  String toString() => 'TitleLabel(title: $title, label: $label)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TitleLabel && other.title == title && other.label == label;
  }

  @override
  int get hashCode => title.hashCode ^ label.hashCode;
}
