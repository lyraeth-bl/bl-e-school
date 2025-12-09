import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedbackAttachmentChip extends StatelessWidget {
  final String rawAttachment;
  final bool openExternally;

  const FeedbackAttachmentChip({
    super.key,
    required this.rawAttachment,
    this.openExternally = false,
  });

  void _showPreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    placeholder: (c, s) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (c, s, e) =>
                        const Center(child: Icon(Icons.broken_image)),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(url.split('/').last),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final normalized = Utils.normalizeToFullUrl(rawAttachment);
    final filename = normalized.split('/').last;
    return GestureDetector(
      onTap: () async {
        if (openExternally) {
          final ok = await Utils.openUrl(normalized);
          if (!ok) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Gagal membuka link')));
          }
        } else {
          _showPreview(context, normalized);
        }
      },
      child: Chip(
        avatar: const CircleAvatar(child: Icon(Icons.attach_file, size: 18)),
        label: Text(filename, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
