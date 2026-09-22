import 'contact.dart';
import 'purchase.dart';
import 'reception_day.dart';

class Client {
  Client({
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
    List<Contact> contacts = const [],
    List<Purchase> purchases = const [],
    List<ReceptionDay>? receptionSchedule,
  }) : contacts = List.unmodifiable(contacts),
       purchases = List.unmodifiable(purchases),
       receptionSchedule = _validateSchedule(
         receptionSchedule ?? ReceptionDay.undefinedWeek(),
       );

  static List<ReceptionDay> _validateSchedule(List<ReceptionDay> schedule) {
    if (schedule.length != 7 ||
        schedule.map((day) => day.weekday).toSet().length != 7) {
      throw ArgumentError(
        'El horario debe contener los siete días sin duplicados',
      );
    }
    final sorted = List<ReceptionDay>.of(schedule)
      ..sort((a, b) => a.weekday.compareTo(b.weekday));
    return List.unmodifiable(sorted);
  }

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
  final List<ReceptionDay> receptionSchedule;

  /// ID, coordenadas y compras no se editan en Clientes v1.1.
  Client copyWith({
    String? commercialName,
    String? businessName,
    String? state,
    String? municipality,
    String? address,
    double? discount,
    bool? hasCredit,
    String? notes,
    List<Contact>? contacts,
    List<ReceptionDay>? receptionSchedule,
  }) => Client(
    id: id,
    commercialName: commercialName ?? this.commercialName,
    businessName: businessName ?? this.businessName,
    state: state ?? this.state,
    municipality: municipality ?? this.municipality,
    address: address ?? this.address,
    latitude: latitude,
    longitude: longitude,
    discount: discount ?? this.discount,
    hasCredit: hasCredit ?? this.hasCredit,
    notes: notes ?? this.notes,
    contacts: contacts ?? this.contacts,
    purchases: purchases,
    receptionSchedule: receptionSchedule ?? this.receptionSchedule,
  );
}
