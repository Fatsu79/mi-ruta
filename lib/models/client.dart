import 'contact.dart';
import 'purchase.dart';

class Client {
  const Client({
    required this.id,
    required this.commercialName,
    required this.businessName,
    required this.state,
    required this.municipality,
    required this.address,
    this.latitude,
    this.longitude,
    required this.discount,
    required this.hasCredit,
    required this.notes,
    this.contacts = const [],
    this.purchases = const [],
  });

  final String id;
  final String commercialName;
  final String businessName;
  final String state;
  final String municipality;
  final String address;
  final double? latitude;
  final double? longitude;
  final double discount;
  final bool hasCredit;
  final String notes;
  final List<Contact> contacts;
  final List<Purchase> purchases;
}
