import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class FeedbackTermsAndConditions extends StatelessWidget {
  const FeedbackTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslatedLabel(termsAndConditionKey),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 16),

          FeedbackTermsAndConditionsFriendly(),
        ],
      ),
    );
  }
}

class FeedbackTermsAndConditionsFriendly extends StatelessWidget {
  const FeedbackTermsAndConditionsFriendly({super.key});

  static const List<String> _items = [
    "Kamu cuma bisa kirim 1 feedback yang aktif dalam satu waktu. Kalau feedback sebelumnya sudah diproses atau dihapus, baru bisa buat lagi.",
    "Kamu hanya bisa kirim 1 feedback per versi aplikasi. Kalau sudah kirim di versi sekarang, tunggu update berikutnya.",
    "Gunakan bahasa yang sopan, jelas, dan langsung ke inti masalah supaya admin gampang paham.",
    "Dilarang pakai bahasa kasar, menghina, atau feedback iseng/spam. Pelanggaran bisa kena demerit atau tindakan disiplin.",
    "Lampiran (foto/screenshot) harus relevan dengan masalah dan tidak melanggar aturan sekolah.",
    "Feedback yang sudah dikirim tidak bisa diedit. Kalau salah, hubungi pihak sekolah untuk bantuan.",
    "Admin sekolah berhak memproses atau menolak feedback yang tidak jelas, tidak relevan, atau melanggar aturan.",
    "Data pribadimu (mis. NIS) hanya dipakai untuk identifikasi internal dan tidak dibagikan ke pihak luar.",
    "Dengan mengirim feedback, kamu berarti setuju dengan semua aturan di atas.",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 120, maxHeight: 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of terms — use Expanded + ListView so it scrolls if long
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                separatorBuilder: (_, __) => SizedBox(height: 8,),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _TermItem(index: index + 1, title: item);
                },
              ),
            ),

            const SizedBox(height: 16),

            // small footer / hint
            Text(
              "Butuh bantua n? Hubungi pihak sekolah.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final int index;
  final String title;

  const _TermItem({required this.index, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number bullet
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(right: 12, top: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),

        // Text
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
