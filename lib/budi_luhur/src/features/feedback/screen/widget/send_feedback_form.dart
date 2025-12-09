// send_feedback_form.dart
import 'dart:io';

// import your cubit & models
import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class SendFeedbackForm extends StatefulWidget {
  /// nis should be passed from AuthCubit (or any auth provider).
  final String nis;

  /// optional initial category list (or you can supply your own)
  final List<String> categories;

  const SendFeedbackForm({
    super.key,
    required this.nis,
    this.categories = const [
      'Home',
      'Kaldik',
      'Jadwal',
      'Absensi',
      'Profile',
      'Details Profile',
      'Settings',
      'Auth',
    ],
  });

  @override
  State<SendFeedbackForm> createState() => _SendFeedbackFormState();
}

class _SendFeedbackFormState extends State<SendFeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _selectedCategory;
  FeedbackType _selectedType = FeedbackType.suggestion;
  File? _attachmentFile;
  bool _submitting = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nisController.text = widget.nis;
  }

  @override
  void dispose() {
    _nisController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() {
        _attachmentFile = File(picked.path);
      });
    } catch (e) {
      // ignore for now, or show a SnackBar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  // map FeedbackType to readable label
  String _typeLabel(FeedbackType t) {
    switch (t) {
      case FeedbackType.complaint:
        return 'Complaint';
      case FeedbackType.suggestion:
        return 'Suggestion';
      case FeedbackType.bug:
        return 'Bug';
      case FeedbackType.question:
        return 'Question';
    }
  }

  Widget _typeChip(FeedbackType t) {
    final bool selected = t == _selectedType;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = t);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withValues(alpha: 0.18),
          ),
        ),
        child: Text(
          _typeLabel(t),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final postCubit = context.read<PostFeedbackCubit>();

    setState(() => _submitting = true);

    try {
      await postCubit.sendFeedback(
        nis: _nisController.text.trim(),
        message: _messageController.text.trim(),
        category: _selectedCategory,
        type: _selectedType,
        attachment: _attachmentFile?.path,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Submit failed: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostFeedbackCubit, PostFeedbackState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          loading: (_) => CircularProgressIndicator(),
          success: (value) async {
            _messageController.clear();
            setState(() => _attachmentFile = null);

            showModalBottomSheet(
              context: context,
              enableDrag: true,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              builder: (context) {
                return SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: Lottie.asset(
                            "assets/animations/check-success.json",
                          ),
                        ),

                        SizedBox(height: 16),

                        Text(
                          "Add feedback success",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),

                        Spacer(),

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: FilledButton(
                            onPressed: () {
                              Get.back();
                              Get.back(result: true);
                            },
                            child: Text(Utils.getTranslatedLabel(goBackKey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          failure: (errorMessage) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed: $errorMessage')));
          },
        );
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    'NIS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _nisController,
                      enabled: false,
                      decoration: const InputDecoration.collapsed(hintText: ''),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Category row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      hint: Text(
                        'Select category',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      items: widget.categories
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCategory = v),
                      decoration: const InputDecoration.collapsed(hintText: ''),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Type chips row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    'Type',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _typeChip(FeedbackType.complaint),
                        _typeChip(FeedbackType.suggestion),
                        _typeChip(FeedbackType.bug),
                        _typeChip(FeedbackType.question),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Attachment row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    'Photo',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (_attachmentFile != null)
                              IconButton(
                                onPressed: () {
                                  setState(() => _attachmentFile = null);
                                },
                                icon: const Icon(Icons.close),
                              ),
                          ],
                        ),
                      ),
                      if (_attachmentFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _attachmentFile!,
                              width: 120,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Message textarea
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    'Message',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: 6,
                      minLines: 4,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Write your message here',
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Message cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Submit button
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitting ? null : _onSubmit,
                  child: _submitting
                      ? Row(
                          children: const [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Sending...'),
                          ],
                        )
                      : const Text('Send Feedback'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
