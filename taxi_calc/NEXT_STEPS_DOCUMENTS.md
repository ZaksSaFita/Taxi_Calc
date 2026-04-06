# Documents Screen - nastavak rada

Datum: 2026-04-06

## Sta je danas uradjeno

- Sredjen je `Documents` screen UI u fajlu `lib/screens/documents.dart`.
- Dodan je bolji header/hero dio ekrana.
- Dodane su summary kartice za:
  - aktivne dokumente
  - dokumente koji uskoro isticu
  - istekle dokumente
- Dodani su filter chipovi za pregled po statusu.
- Dodan je empty state kad nema dokumenata ili kad filter nema rezultata.
- Dodan je bottom sheet za:
  - dodavanje dokumenta
  - edit dokumenta
  - pregled detalja dokumenta
  - brisanje dokumenta
- Dodani su novi stringovi u `lib/core/localization/app_strings.dart`:
  - `editDocument`
  - `saveDocument`
  - `documentSaved`
  - `documentUpdated`
  - `deleteDocument`
  - `documentDeleted`
  - `noDocumentsForFilter`
  - `statusLabel`

## Trenutno stanje

- `Documents` screen trenutno radi sa lokalnom in-memory listom unutar `documents.dart`.
- Drift tabela za dokumente vec postoji u:
  - `lib/data/tables/documents_table.dart`
- Ali ekran jos nije spojen na bazu.

## Sta je ostalo da se uradi

1. Spojiti `Documents` screen na Drift bazu.
2. U `lib/data/database.dart` dodati `Documents` tabelu u `@DriftDatabase(...)`.
3. Povecati `schemaVersion`.
4. Dodati migraciju za kreiranje `documents` tabele ako baza vec postoji.
5. Napraviti `DocumentsProvider` u `lib/data/providers/documents_provider.dart`.
6. Zamijeniti `_DocumentItem` in-memory model sa Drift `Document` modelom ili mapiranjem iz baze.
7. U `documents.dart` povezati:
   - load svih dokumenata
   - create dokumenta
   - update dokumenta
   - delete dokumenta
8. Nakon toga pokrenuti generator i provjeru:
   - `dart run build_runner build --delete-conflicting-outputs`
   - `dart format ...`
   - `flutter analyze`

## Bitna napomena / blokada od danas

- Pokusano je povezivanje na bazu.
- Problem: `dart` / `flutter` procesi su u ovom okruzenju visili i timeoutali tokom:
  - `build_runner`
  - `dart format`
  - osnovnih `dart` / `flutter` komandi
- Zbog toga DB integracija nije ostavljena u polovicnom stanju, nego je vracena na sigurnu UI-only verziju.

## Preporuceni redoslijed za sutra

1. Provjeriti da li `dart` i `flutter` komande normalno rade.
2. Ako rade:
   - vratiti DB integraciju za documents
   - generisati `database.g.dart`
   - pustiti `flutter analyze`
3. Nakon toga po zelji dodati:
   - potvrdu prije brisanja dokumenta
   - sortiranje po najblizem isteku
   - automatski seed / demo dokumente za test

## Fajlovi koje prvo otvoriti sutra

- `lib/screens/documents.dart`
- `lib/core/localization/app_strings.dart`
- `lib/data/tables/documents_table.dart`
- `lib/data/database.dart`
- `lib/data/providers/daily_entries_provider.dart`

## Kratka ideja za sljedeci korak

Najbrzi nastavak je:

- napraviti `DocumentsProvider`
- ubaciti `Documents` u `AppDatabase`
- zamijeniti `_documents` listu sa podacima iz baze

