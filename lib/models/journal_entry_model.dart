enum JournalEntryType { calm, energy, neutral }

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.dateTime,
    required this.product1,
    required this.product1Full,
    required this.product2,
    required this.product2Type,
    required this.location,
    required this.durationHours,
    required this.entryType,
    required this.recommendationText,
    required this.userNote,
    required this.arImageUrl,
  });

  final String id;
  final DateTime dateTime;
  final String product1;
  final String product1Full;
  final String product2;
  final String product2Type;
  final String location;
  final double durationHours;
  final JournalEntryType entryType;
  final String recommendationText;
  final String userNote;
  final String arImageUrl;

  String get title => '$product1Full + $product2';
}

class JournalMockData {
  static final List<JournalEntry> entries = [
    JournalEntry(
      id: 'j-2027-03-17-01',
      dateTime: DateTime(2027, 3, 17, 8, 42),
      product1: 'YSL',
      product1Full: 'Y Eau de Perfume',
      product2: 'Calm',
      product2Type: 'Linalool • Calm',
      location: 'Paris, FR',
      durationHours: 7.2,
      entryType: JournalEntryType.calm,
      recommendationText:
          'Elevated morning cortisol, Anchor aligned perfectly, your most stable wear this month.',
      userNote:
          'Wore this to my presentation - felt so composed the whole morning!',
      arImageUrl: '',
    ),
    JournalEntry(
      id: 'j-2027-03-16-01',
      dateTime: DateTime(2027, 3, 16, 9, 0),
      product1: 'YSL',
      product1Full: 'Libre',
      product2: 'Energy',
      product2Type: 'Limonene • Energy',
      location: 'Paris, FR',
      durationHours: 7.2,
      entryType: JournalEntryType.energy,
      recommendationText:
          'The blend amplified your alertness window and stayed consistent through your focus block.',
      userNote: 'Kept me energized before noon without feeling too sharp.',
      arImageUrl: '',
    ),
    JournalEntry(
      id: 'j-2027-03-10-01',
      dateTime: DateTime(2027, 3, 10, 7, 55),
      product1: 'YSL',
      product1Full: 'Mon Paris',
      product2: 'Neutral',
      product2Type: 'Bergamot • Neutral',
      location: 'Paris, FR',
      durationHours: 6.4,
      entryType: JournalEntryType.neutral,
      recommendationText:
          'Balanced chemistry this morning, projection was clean and moderate during commute hours.',
      userNote: 'A smooth everyday profile for office and quick meetings.',
      arImageUrl: '',
    ),
    JournalEntry(
      id: 'j-2027-03-08-01',
      dateTime: DateTime(2027, 3, 8, 8, 15),
      product1: 'YSL',
      product1Full: 'Y Eau de Perfume',
      product2: 'Neutral',
      product2Type: 'Linalool • Neutral',
      location: 'Paris, FR',
      durationHours: 6.9,
      entryType: JournalEntryType.neutral,
      recommendationText:
          'Skin hydration supported a stable dry-down with even diffusion through late afternoon.',
      userNote: 'Subtle and reliable, especially for a long desk day.',
      arImageUrl: '',
    ),
    JournalEntry(
      id: 'j-2027-03-05-01',
      dateTime: DateTime(2027, 3, 5, 8, 5),
      product1: 'YSL',
      product1Full: 'Y Eau de Perfume',
      product2: 'Calm',
      product2Type: 'Linalool • Calm',
      location: 'Paris, FR',
      durationHours: 7.0,
      entryType: JournalEntryType.calm,
      recommendationText:
          'Cortisol trend remained low and the composition preserved a clear, grounded signature.',
      userNote: 'Great on a high-pressure morning, felt centered.',
      arImageUrl: '',
    ),
    JournalEntry(
      id: 'j-2027-03-02-01',
      dateTime: DateTime(2027, 3, 2, 9, 6),
      product1: 'YSL',
      product1Full: 'Libre',
      product2: 'Energy',
      product2Type: 'Limonene • Energy',
      location: 'Paris, FR',
      durationHours: 6.8,
      entryType: JournalEntryType.energy,
      recommendationText:
          'Morning response indicated elevated vitality and above-average wakefulness retention.',
      userNote: 'Strong start for errands and a short travel day.',
      arImageUrl: '',
    ),
  ];
}
