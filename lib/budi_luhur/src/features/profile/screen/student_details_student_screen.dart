import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsStudentScreen extends StatelessWidget {
  const StudentDetailsStudentScreen({super.key});

  static Widget routeInstance() {
    return StudentDetailsStudentScreen();
  }

  String _safeFormatDate(DateTime? dt) {
    if (dt == null) return "-";
    try {
      return Utils.formatDays(dt, locale: "id_ID");
    } catch (_) {
      final d = dt.toLocal();
      return "${d.day.toString().padLeft(2, '0')} ${Utils.getMonthName(d.month)} ${d.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsProfile = context.read<AuthCubit>().getStudentDetails;

    String safeNullable(String? v) => v == null || v.isEmpty ? "-" : v;

    return Scaffold(
      appBar: AppBar(title: Text(Utils.getTranslatedLabel(detailsProfileKey))),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundImage:
                      (detailsProfile.profileImageUrl != null &&
                          detailsProfile.profileImageUrl!.isNotEmpty)
                      ? NetworkImage(detailsProfile.profileImageUrl!)
                      : null,
                  child:
                      (detailsProfile.profileImageUrl == null ||
                          detailsProfile.profileImageUrl!.isEmpty)
                      ? Text(
                          (detailsProfile.nama != null &&
                                  detailsProfile.nama!.isNotEmpty)
                              ? detailsProfile.nama![0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        safeNullable(detailsProfile.nama),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "NIS: ${safeNullable(detailsProfile.nis)}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Detail tiles
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(unitKey),
              value: safeNullable(
                "${detailsProfile.unit?.substring(0, 3)} Budi Luhur",
              ),
              icon: Icons.school,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(nisKey),
              value: safeNullable(detailsProfile.nis),
              icon: Icons.confirmation_number,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(nisnKey),
              value: safeNullable(detailsProfile.nisn),
              icon: Icons.badge,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(dateOfBirthKey),
              value: _safeFormatDate(detailsProfile.tanggalLahir),
              icon: Icons.date_range,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(genderKey),
              value: safeNullable(detailsProfile.jenisKelamin),
              icon: (detailsProfile.jenisKelamin?.toLowerCase() == "perempuan")
                  ? Icons.female
                  : Icons.male,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(religionKey),
              value: safeNullable(detailsProfile.agama),
              icon: Utils.iconForReligion(
                (detailsProfile.agama ?? "").toLowerCase(),
              ),
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(classKey),
              value: safeNullable(detailsProfile.kelasSaatIni),
              icon: Icons.school,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(semesterKey),
              value: safeNullable(detailsProfile.semester),
              icon: Icons.menu_book,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(classNumberKey),
              value: safeNullable(detailsProfile.noKelasSaatIni),
              icon: Icons.meeting_room,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(addressKey),
              value: safeNullable(detailsProfile.alamat),
              icon: Icons.home,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(phoneNumberKey),
              value: safeNullable(
                detailsProfile.noTelepon ?? detailsProfile.noTeleponOrangTua,
              ),
              icon: Icons.phone,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(emailKey),
              value: safeNullable(detailsProfile.email),
              icon: Icons.email,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(fatherNameKey),
              value: safeNullable(detailsProfile.namaAyah),
              icon: Icons.person,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(motherNameKey),
              value: safeNullable(detailsProfile.namaIbu),
              icon: Icons.person,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(admissionDateKey),
              value: _safeFormatDate(detailsProfile.tanggalDiTerima),
              icon: Icons.calendar_today,
            ),
            _buildProfileDetailsTile(
              context,
              label: Utils.getTranslatedLabel(statusKey),
              value: safeNullable(
                detailsProfile.aktif ?? detailsProfile.statusKeluarga,
              ),
              icon: Icons.info,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailsTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.5),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1a212121),
                  offset: Offset(0, 10),
                  blurRadius: 16,
                ),
              ],
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(
              icon,
              color:
                  iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * (0.05)),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty ? "-" : value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
