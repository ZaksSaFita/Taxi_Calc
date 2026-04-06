import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static AppStrings of(BuildContext context) {
    return AppStrings(Localizations.localeOf(context));
  }

  bool get _isBs => locale.languageCode == 'bs';
  bool get _isDe => locale.languageCode == 'de';

  String get appName {
    if (_isBs) return 'Taxi Kalkulator';
    if (_isDe) return 'Taxi Rechner';
    return 'Taxi Calculator';
  }

  String get menuClose {
    if (_isBs) return 'Zatvori';
    if (_isDe) return 'Schliessen';
    return 'Close';
  }

  String get menuHome {
    if (_isBs) return 'Pocetna';
    if (_isDe) return 'Start';
    return 'Home';
  }

  String get menuServices {
    if (_isBs) return 'Servisi';
    if (_isDe) return 'Services';
    return 'Services';
  }

  String get menuDocuments {
    if (_isBs) return 'Dokumenti';
    if (_isDe) return 'Dokumente';
    return 'Documents';
  }

  String get menuSettings {
    if (_isBs) return 'Postavke';
    if (_isDe) return 'Einstellungen';
    return 'Settings';
  }

  String get homeTitle {
    if (_isBs) return 'Kalkulator Zarade';
    if (_isDe) return 'Einnahmenrechner';
    return 'Earnings Calculator';
  }

  String get daily {
    if (_isBs) return 'Dnevno';
    if (_isDe) return 'Taeglich';
    return 'Daily';
  }

  String get weekly {
    if (_isBs) return 'Sedmicno';
    if (_isDe) return 'Woechentlich';
    return 'Weekly';
  }

  String get monthly {
    if (_isBs) return 'Mjesecno';
    if (_isDe) return 'Monatlich';
    return 'Monthly';
  }

  String get yearly {
    if (_isBs) return 'Godisnje';
    if (_isDe) return 'Jaehrlich';
    return 'Yearly';
  }

  String get addEntry {
    if (_isBs) return 'Dodaj Unos';
    if (_isDe) return 'Eintrag Hinzufuegen';
    return 'Add Entry';
  }

  String get settingsTitle {
    if (_isBs) return 'Postavke';
    if (_isDe) return 'Einstellungen';
    return 'Settings';
  }

  String get servicesTitle {
    if (_isBs) return 'Servisi';
    if (_isDe) return 'Services';
    return 'Services';
  }

  String get documentsTitle {
    if (_isBs) return 'Dokumenti';
    if (_isDe) return 'Dokumente';
    return 'Documents';
  }

  String get language {
    if (_isBs) return 'Jezik';
    if (_isDe) return 'Sprache';
    return 'Language';
  }

  String get languageHelp {
    if (_isBs) return 'Promijeni jezik aplikacije';
    if (_isDe) return 'Sprache der App aendern';
    return 'Change app language';
  }

  String get selectDate {
    if (_isBs) return 'Izaberi datum';
    if (_isDe) return 'Datum waehlen';
    return 'Select date';
  }

  String get dailyTitle {
    if (_isBs) return 'Dnevna Zarada';
    if (_isDe) return 'Taegliche Einnahmen';
    return 'Daily Earnings';
  }

  String get weeklyTitle {
    if (_isBs) return 'Sedmicna Zarada';
    if (_isDe) return 'Woechentliche Einnahmen';
    return 'Weekly Earnings';
  }

  String get monthlyTitle {
    if (_isBs) return 'Mjesecna Zarada';
    if (_isDe) return 'Monatliche Einnahmen';
    return 'Monthly Earnings';
  }

  String get yearlyTitle {
    if (_isBs) return 'Godisnja Zarada';
    if (_isDe) return 'Jaehrliche Einnahmen';
    return 'Yearly Earnings';
  }

  String get addDailyEntryTitle {
    if (_isBs) return 'Dodaj Dnevni Unos';
    if (_isDe) return 'Taeglichen Eintrag Hinzufuegen';
    return 'Add Daily Entry';
  }

  String get requiredSection {
    if (_isBs) return 'Obavezno';
    if (_isDe) return 'Pflichtfelder';
    return 'Required';
  }

  String get existingEntryChip {
    if (_isBs) return 'Postojeci unos';
    if (_isDe) return 'Vorhandener Eintrag';
    return 'Existing entry';
  }

  String get grossRevenue {
    if (_isBs) return 'Pazar (Brutto)';
    if (_isDe) return 'Umsatz (Brutto)';
    return 'Revenue (Gross)';
  }

  String get kilometrageOptional {
    if (_isBs) return 'Kilometraza (opcionalno)';
    if (_isDe) return 'Kilometerstand (optional)';
    return 'Mileage (optional)';
  }

  String get fuelOptional {
    if (_isBs) return 'Gorivo (opcionalno)';
    if (_isDe) return 'Kraftstoff (optional)';
    return 'Fuel (optional)';
  }

  String get foodOptional {
    if (_isBs) return 'Hrana (opcionalno)';
    if (_isDe) return 'Essen (optional)';
    return 'Food (optional)';
  }

  String get otherOptional {
    if (_isBs) return 'Ostalo (opcionalno)';
    if (_isDe) return 'Sonstiges (optional)';
    return 'Other (optional)';
  }

  String get expenseItemsTitle {
    if (_isBs) return 'Stavke troska';
    if (_isDe) return 'Kostenpositionen';
    return 'Expense items';
  }

  String get addItemTooltip {
    if (_isBs) return 'Dodaj stavku';
    if (_isDe) return 'Position hinzufuegen';
    return 'Add item';
  }

  String get chooseServiceType {
    if (_isBs) return 'Izaberi tip servisa';
    if (_isDe) return 'Service-Typ waehlen';
    return 'Choose service type';
  }

  String get enterServiceAmount {
    if (_isBs) return 'Unesi cijenu servisa';
    if (_isDe) return 'Servicepreis eingeben';
    return 'Enter service amount';
  }

  String get addService {
    if (_isBs) return 'Dodaj servis';
    if (_isDe) return 'Service hinzufuegen';
    return 'Add service';
  }

  String get noExpenseItems {
    if (_isBs) return 'Klikni + i dodaj gorivo/hranu/servis/ostalo.';
    if (_isDe) {
      return 'Tippe auf + und fuege Kraftstoff/Essen/Service/Sonstiges hinzu.';
    }
    return 'Tap + to add fuel/food/service/other.';
  }

  String get noServiceItems {
    if (_isBs) return 'Klikni + i dodaj servis.';
    if (_isDe) return 'Tippe auf + und fuege Service hinzu.';
    return 'Tap + to add service.';
  }

  String get amountLabel {
    if (_isBs) return 'Iznos';
    if (_isDe) return 'Betrag';
    return 'Amount';
  }

  String get totalExpenses {
    if (_isBs) return 'Ukupno troskovi';
    if (_isDe) return 'Gesamtkosten';
    return 'Total expenses';
  }

  String get year {
    if (_isBs) return 'Godina';
    if (_isDe) return 'Jahr';
    return 'Year';
  }

  String get chooseYear {
    if (_isBs) return 'Izaberi godinu';
    if (_isDe) return 'Jahr waehlen';
    return 'Choose year';
  }

  String get net {
    if (_isBs) return 'Netto';
    if (_isDe) return 'Netto';
    return 'Net';
  }

  String get noteOptional {
    if (_isBs) return 'Napomena (opcionalno)';
    if (_isDe) return 'Notiz (optional)';
    return 'Note (optional)';
  }

  String get saving {
    if (_isBs) return 'Cuvam...';
    if (_isDe) return 'Speichern...';
    return 'Saving...';
  }

  String get saveEntry {
    if (_isBs) return 'Sacuvaj unos';
    if (_isDe) return 'Eintrag speichern';
    return 'Save entry';
  }

  String get noMoreItems {
    if (_isBs) return 'Sve stavke su vec dodane.';
    if (_isDe) return 'Alle Positionen wurden bereits hinzugefuegt.';
    return 'All items are already added.';
  }

  String get entryUpdated {
    if (_isBs) return 'Postojeci unos je azuriran.';
    if (_isDe) return 'Vorhandener Eintrag wurde aktualisiert.';
    return 'Existing entry was updated.';
  }

  String get entrySaved {
    if (_isBs) return 'Unos sacuvan.';
    if (_isDe) return 'Eintrag gespeichert.';
    return 'Entry saved.';
  }

  String get requiredField {
    if (_isBs) return 'Obavezno polje';
    if (_isDe) return 'Pflichtfeld';
    return 'Required field';
  }

  String get invalidNumber {
    if (_isBs) return 'Neispravan broj';
    if (_isDe) return 'Ungueltige Zahl';
    return 'Invalid number';
  }

  String get numberMustBeNonNegative {
    if (_isBs) return 'Mora biti >= 0';
    if (_isDe) return 'Muss >= 0 sein';
    return 'Must be >= 0';
  }

  String get noDataForDate {
    if (_isBs) return 'Nema podataka za izabrani datum.';
    if (_isDe) return 'Keine Daten fuer das ausgewaehlte Datum.';
    return 'No data for selected date.';
  }

  String get noDataForYear {
    if (_isBs) return 'Nema podataka za izabranu godinu.';
    if (_isDe) return 'Keine Daten fuer das ausgewaehlte Jahr.';
    return 'No data for selected year.';
  }

  String get noDataForMonth {
    if (_isBs) return 'Nema podataka za izabrani mjesec.';
    if (_isDe) return 'Keine Daten fuer den ausgewaehlten Monat.';
    return 'No data for selected month.';
  }

  String get yearlyTrend {
    if (_isBs) return 'Trend po mjesecima';
    if (_isDe) return 'Monatlicher Trend';
    return 'Monthly trend';
  }

  String entriesForMonth(int month) {
    if (_isBs) return 'Unosi za ${monthName(month)}';
    if (_isDe) return 'Eintraege fuer ${monthName(month)}';
    return 'Entries for ${monthName(month)}';
  }

  String get totalRevenue {
    if (_isBs) return 'Ukupna zarada';
    if (_isDe) return 'Gesamteinnahmen';
    return 'Total revenue';
  }

  String get entries {
    if (_isBs) return 'Unosi';
    if (_isDe) return 'Eintraege';
    return 'Entries';
  }

  String get entriesCount {
    if (_isBs) return 'Broj unosa';
    if (_isDe) return 'Eintraege';
    return 'Entries count';
  }

  String get incomeLabel {
    if (_isBs) return 'Prihod';
    if (_isDe) return 'Einnahmen';
    return 'Income';
  }

  String get expenseLabel {
    if (_isBs) return 'Trosak';
    if (_isDe) return 'Kosten';
    return 'Expense';
  }

  String get noteLabel {
    if (_isBs) return 'Napomena';
    if (_isDe) return 'Notiz';
    return 'Note';
  }

  String get expenseItemsSubtitle {
    if (_isBs) return 'Stavke troskova:';
    if (_isDe) return 'Kostenpositionen:';
    return 'Expense items:';
  }

  String get weeklyScreenPlaceholder {
    if (_isBs) return 'Sedmicni ekran';
    if (_isDe) return 'Woechentlicher Bildschirm';
    return 'Weekly screen';
  }

  String get monthlyScreenPlaceholder {
    if (_isBs) return 'Mjesecni ekran';
    if (_isDe) return 'Monatlicher Bildschirm';
    return 'Monthly screen';
  }

  String get servicesScreenPlaceholder {
    if (_isBs) return 'Ekran servisa';
    if (_isDe) return 'Service Bildschirm';
    return 'Services screen';
  }

  String get noServiceDataForYear {
    if (_isBs) return 'Nema servisnih podataka za izabranu godinu.';
    if (_isDe) return 'Keine Service-Daten fuer das ausgewaehlte Jahr.';
    return 'No service data for selected year.';
  }

  String get serviceSpend {
    if (_isBs) return 'Ukupno servis';
    if (_isDe) return 'Service gesamt';
    return 'Total service spend';
  }

  String get serviceItemsCount {
    if (_isBs) return 'Broj servis stavki';
    if (_isDe) return 'Anzahl Servicepositionen';
    return 'Service items count';
  }

  String get lastServiceDate {
    if (_isBs) return 'Zadnji servis';
    if (_isDe) return 'Letzter Service';
    return 'Last service date';
  }

  String get averagePerServiceItem {
    if (_isBs) return 'Prosjek po stavci';
    if (_isDe) return 'Durchschnitt pro Position';
    return 'Average per item';
  }

  String get serviceDetailsTitle {
    if (_isBs) return 'Detalji servisa';
    if (_isDe) return 'Service-Details';
    return 'Service details';
  }

  String get serviceHistory {
    if (_isBs) return 'Historija servisa';
    if (_isDe) return 'Serviceverlauf';
    return 'Service history';
  }

  String get serviceDateLabel {
    if (_isBs) return 'Datum';
    if (_isDe) return 'Datum';
    return 'Date';
  }

  String get serviceTypesCount {
    if (_isBs) return 'Tipovi servisa';
    if (_isDe) return 'Service-Typen';
    return 'Service types';
  }

  String get serviceByType {
    if (_isBs) return 'Servis po tipu';
    if (_isDe) return 'Service nach Typ';
    return 'Service by type';
  }

  String get serviceGeneral {
    if (_isBs) return 'Opsti servis';
    if (_isDe) return 'Allgemeiner Service';
    return 'General service';
  }

  String get documentsScreenPlaceholder {
    if (_isBs) return 'Ekran dokumenata';
    if (_isDe) return 'Dokumente Bildschirm';
    return 'Documents screen';
  }

  String get documentsIntro {
    if (_isBs) return 'Prati dokumente i vidi sta uskoro istice.';
    if (_isDe) return 'Behalte Dokumente im Blick und sehe, was bald ablaeuft.';
    return 'Track documents and see what expires soon.';
  }

  String get addDocument {
    if (_isBs) return 'Dodaj dokument';
    if (_isDe) return 'Dokument hinzufuegen';
    return 'Add document';
  }

  String get editDocument {
    if (_isBs) return 'Uredi dokument';
    if (_isDe) return 'Dokument bearbeiten';
    return 'Edit document';
  }

  String get saveDocument {
    if (_isBs) return 'Sacuvaj dokument';
    if (_isDe) return 'Dokument speichern';
    return 'Save document';
  }

  String get documentSaved {
    if (_isBs) return 'Dokument sacuvan.';
    if (_isDe) return 'Dokument gespeichert.';
    return 'Document saved.';
  }

  String get documentUpdated {
    if (_isBs) return 'Dokument azuriran.';
    if (_isDe) return 'Dokument aktualisiert.';
    return 'Document updated.';
  }

  String get deleteDocument {
    if (_isBs) return 'Obrisi dokument';
    if (_isDe) return 'Dokument loeschen';
    return 'Delete document';
  }

  String get documentDeleted {
    if (_isBs) return 'Dokument obrisan.';
    if (_isDe) return 'Dokument geloescht.';
    return 'Document deleted.';
  }

  String get chooseDocumentTemplate {
    if (_isBs) return 'Izaberi template dokumenta';
    if (_isDe) return 'Dokumentvorlage waehlen';
    return 'Choose document template';
  }

  String get customDocument {
    if (_isBs) return 'Svoj dokument';
    if (_isDe) return 'Eigenes Dokument';
    return 'Custom document';
  }

  String get allDocuments {
    if (_isBs) return 'Svi';
    if (_isDe) return 'Alle';
    return 'All';
  }

  String get activeDocuments {
    if (_isBs) return 'Aktivni';
    if (_isDe) return 'Aktiv';
    return 'Active';
  }

  String get expiringSoonDocuments {
    if (_isBs) return 'Uskoro isticu';
    if (_isDe) return 'Laufen bald ab';
    return 'Expiring soon';
  }

  String get expiredDocuments {
    if (_isBs) return 'Istekli';
    if (_isDe) return 'Abgelaufen';
    return 'Expired';
  }

  String get documentType {
    if (_isBs) return 'Tip dokumenta';
    if (_isDe) return 'Dokumenttyp';
    return 'Document type';
  }

  String get documentName {
    if (_isBs) return 'Naziv dokumenta';
    if (_isDe) return 'Dokumentname';
    return 'Document name';
  }

  String get relatedToOptional {
    if (_isBs) return 'Za vozilo/osobu (opcionalno)';
    if (_isDe) return 'Fuer Fahrzeug/Person (optional)';
    return 'For vehicle/person (optional)';
  }

  String get documentNumberOptional {
    if (_isBs) return 'Broj dokumenta (opcionalno)';
    if (_isDe) return 'Dokumentnummer (optional)';
    return 'Document number (optional)';
  }

  String get issueDateOptional {
    if (_isBs) return 'Datum izdavanja (opcionalno)';
    if (_isDe) return 'Ausstellungsdatum (optional)';
    return 'Issue date (optional)';
  }

  String get expiryDate {
    if (_isBs) return 'Datum isteka';
    if (_isDe) return 'Ablaufdatum';
    return 'Expiry date';
  }

  String get reminderDays {
    if (_isBs) return 'Podsjetnik (dana ranije)';
    if (_isDe) return 'Erinnerung (Tage vorher)';
    return 'Reminder (days before)';
  }

  String get documentDetails {
    if (_isBs) return 'Detalji dokumenta';
    if (_isDe) return 'Dokumentdetails';
    return 'Document details';
  }

  String get statusLabel {
    if (_isBs) return 'Status';
    if (_isDe) return 'Status';
    return 'Status';
  }

  String get noDocumentsYet {
    if (_isBs) return 'Jos nema dokumenata. Dodaj prvi dokument.';
    if (_isDe) return 'Noch keine Dokumente. Fuege das erste Dokument hinzu.';
    return 'No documents yet. Add your first document.';
  }

  String get noDocumentsForFilter {
    if (_isBs) return 'Nema dokumenata za izabrani filter.';
    if (_isDe) return 'Keine Dokumente fuer den ausgewaehlten Filter.';
    return 'No documents for the selected filter.';
  }

  String get activeStatus {
    if (_isBs) return 'Aktivan';
    if (_isDe) return 'Aktiv';
    return 'Active';
  }

  String get expiringSoonStatus {
    if (_isBs) return 'Istice uskoro';
    if (_isDe) return 'Laeuft bald ab';
    return 'Expiring soon';
  }

  String get expiredStatus {
    if (_isBs) return 'Istekao';
    if (_isDe) return 'Abgelaufen';
    return 'Expired';
  }

  String get registrationDoc {
    if (_isBs) return 'Registracija';
    if (_isDe) return 'Zulassung';
    return 'Registration';
  }

  String get insuranceDoc {
    if (_isBs) return 'Osiguranje';
    if (_isDe) return 'Versicherung';
    return 'Insurance';
  }

  String get taxiLicenseDoc {
    if (_isBs) return 'Taksi licenca';
    if (_isDe) return 'Taxi-Lizenz';
    return 'Taxi license';
  }

  String get taxiSignDoc {
    if (_isBs) return 'Taksi oznaka';
    if (_isDe) return 'Taxi-Schild';
    return 'Taxi sign';
  }

  String get drivingLicenseDoc {
    if (_isBs) return 'Vozacka dozvola';
    if (_isDe) return 'Fuehrerschein';
    return 'Driving license';
  }

  String get idCardDoc {
    if (_isBs) return 'Licna karta';
    if (_isDe) return 'Personalausweis';
    return 'ID card';
  }

  String get passportDoc {
    if (_isBs) return 'Pasos';
    if (_isDe) return 'Reisepass';
    return 'Passport';
  }

  String get technicalInspectionDoc {
    if (_isBs) return 'Tehnicki pregled';
    if (_isDe) return 'Technische Pruefung';
    return 'Technical inspection';
  }

  String get fireExtinguisherDoc {
    if (_isBs) return 'PP aparat';
    if (_isDe) return 'Feuerloescher';
    return 'Fire extinguisher';
  }

  String get disinfectionDoc {
    if (_isBs) return 'Dezinfekcija';
    if (_isDe) return 'Desinfektion';
    return 'Disinfection';
  }

  String get otherDoc {
    if (_isBs) return 'Ostali dokument';
    if (_isDe) return 'Sonstiges Dokument';
    return 'Other document';
  }

  String documentTypeLabel(String key) {
    switch (key) {
      case 'registration':
        return registrationDoc;
      case 'insurance':
        return insuranceDoc;
      case 'taxi_license':
        return taxiLicenseDoc;
      case 'taxi_sign':
        return taxiSignDoc;
      case 'driving_license':
        return drivingLicenseDoc;
      case 'id_card':
        return idCardDoc;
      case 'passport':
        return passportDoc;
      case 'technical_inspection':
        return technicalInspectionDoc;
      case 'fire_extinguisher':
        return fireExtinguisherDoc;
      case 'disinfection':
        return disinfectionDoc;
      case 'custom':
        return customDocument;
      case 'other':
        return otherDoc;
      default:
        return key;
    }
  }

  String get fuelLabel {
    if (_isBs) return 'Gorivo';
    if (_isDe) return 'Kraftstoff';
    return 'Fuel';
  }

  String get foodLabel {
    if (_isBs) return 'Hrana';
    if (_isDe) return 'Essen';
    return 'Food';
  }

  String get serviceLabel {
    if (_isBs) return 'Servis';
    if (_isDe) return 'Service';
    return 'Service';
  }

  String get serviceSmall {
    if (_isBs) return 'Mali servis';
    if (_isDe) return 'Kleiner Service';
    return 'Small service';
  }

  String get serviceBig {
    if (_isBs) return 'Veliki servis';
    if (_isDe) return 'Grosser Service';
    return 'Big service';
  }

  String get serviceFrontBrakes {
    if (_isBs) return 'Kocnice prednje';
    if (_isDe) return 'Bremsen vorne';
    return 'Front brakes';
  }

  String get serviceRearBrakes {
    if (_isBs) return 'Kocnice zadnje';
    if (_isDe) return 'Bremsen hinten';
    return 'Rear brakes';
  }

  String get serviceFrontDiscs {
    if (_isBs) return 'Diskovi prednji';
    if (_isDe) return 'Scheiben vorne';
    return 'Front discs';
  }

  String get serviceRearDiscs {
    if (_isBs) return 'Diskovi zadnji';
    if (_isDe) return 'Scheiben hinten';
    return 'Rear discs';
  }

  String get serviceShockAbsorbers {
    if (_isBs) return 'Amortizeri';
    if (_isDe) return 'Stossdaempfer';
    return 'Shock absorbers';
  }

  String get serviceTires {
    if (_isBs) return 'Gume';
    if (_isDe) return 'Reifen';
    return 'Tires';
  }

  String get serviceBattery {
    if (_isBs) return 'Akumulator';
    if (_isDe) return 'Batterie';
    return 'Battery';
  }

  String get serviceClutch {
    if (_isBs) return 'Kvacilo';
    if (_isDe) return 'Kupplung';
    return 'Clutch';
  }

  String get serviceOther {
    if (_isBs) return 'Ostalo';
    if (_isDe) return 'Sonstiges';
    return 'Other';
  }

  String serviceSubtypeLabel(String key) {
    switch (key) {
      case 'small_service':
        return serviceSmall;
      case 'big_service':
        return serviceBig;
      case 'front_brakes':
        return serviceFrontBrakes;
      case 'rear_brakes':
        return serviceRearBrakes;
      case 'front_discs':
        return serviceFrontDiscs;
      case 'rear_discs':
        return serviceRearDiscs;
      case 'shock_absorbers':
        return serviceShockAbsorbers;
      case 'tires':
        return serviceTires;
      case 'battery':
        return serviceBattery;
      case 'clutch':
        return serviceClutch;
      case 'other_service':
        return serviceOther;
      case 'oil_change':
        return serviceSmall;
      case 'filters':
        return serviceSmall;
      default:
        return serviceLabel;
    }
  }

  String get otherLabel {
    if (_isBs) return 'Ostalo';
    if (_isDe) return 'Sonstiges';
    return 'Other';
  }

  String monthName(int month) {
    return DateFormat.MMMM(
      locale.languageCode,
    ).format(DateTime(2026, month, 1));
  }

  String expenseLabelFromStored(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.startsWith('service:')) {
      final subtype = normalized.substring('service:'.length);
      return '$serviceLabel - ${serviceSubtypeLabel(subtype)}';
    }
    switch (normalized) {
      case 'fuel':
      case 'gorivo':
      case 'kraftstoff':
        return fuelLabel;
      case 'food':
      case 'hrana':
      case 'essen':
        return foodLabel;
      case 'service':
      case 'servis':
        return serviceLabel;
      case 'other':
      case 'ostalo':
      case 'sonstiges':
        return otherLabel;
      default:
        return value;
    }
  }
}
