import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuardianDetailsContainer extends StatelessWidget {
  const GuardianDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final studentDetails = context.read<AuthCubit>().getStudentDetails;

    final motherName = studentDetails.namaIbu;
    final motherWork = studentDetails.pekerjaanIbu;
    final motherLastStudy = studentDetails.pendidikanTerakhirIbu;

    final fatherName = studentDetails.namaAyah;
    final fatherWork = studentDetails.pekerjaanAyah;
    final fatherLastStudy = studentDetails.pendidikanTerakhirAyah;

    final parentAddress = studentDetails.alamatOrangTua;
    final parentNumber = studentDetails.noTeleponOrangTua;

    final guardianName = studentDetails.namaWali;
    final guardianNumber = studentDetails.noTeleponWali;
    final guardianAddress = studentDetails.alamatWali;
    final guardianWork = studentDetails.pekerjaanWali;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          Utils.getTranslatedLabel(guardianDetailsKey),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            top: 24,
            right: 24,
            bottom: Utils.getScrollViewBottomPadding(context),
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslatedLabel(parentsDetailsKey),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24),

              GuardiansDetailsListContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuardiansDetailsRowList(
                      titleKey: motherNameKey,
                      value: motherName,
                    ),

                    SizedBox(height: 24),

                    GuardiansDetailsRowList(
                      titleKey: motherWorkKey,
                      value: motherWork,
                    ),

                    SizedBox(height: 24),

                    GuardiansDetailsRowList(
                      titleKey: motherLastStudyKey,
                      value: motherLastStudy,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              GuardiansDetailsListContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuardiansDetailsRowList(
                      titleKey: fatherNameKey,
                      value: fatherName,
                    ),

                    SizedBox(height: 24),

                    GuardiansDetailsRowList(
                      titleKey: fatherWorkKey,
                      value: fatherWork,
                    ),

                    SizedBox(height: 24),

                    GuardiansDetailsRowList(
                      titleKey: fatherLastStudyKey,
                      value: fatherLastStudy,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              GuardiansDetailsListContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuardiansDetailsRowList(
                      titleKey: phoneNumberKey,
                      value: parentNumber,
                    ),

                    const SizedBox(height: 24),

                    GuardiansDetailsColumnList(
                      titleKey: addressKey,
                      value: parentAddress,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              Text(
                Utils.getTranslatedLabel(guardianDetailsKey),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24),

              GuardiansDetailsListContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuardiansDetailsRowList(
                      titleKey: guardianNameKey,
                      value: guardianName,
                    ),

                    const SizedBox(height: 24),

                    GuardiansDetailsRowList(
                      titleKey: guardianNumberKey,
                      value: guardianNumber,
                    ),

                    const SizedBox(height: 24),

                    GuardiansDetailsRowList(
                      titleKey: guardianWorkKey,
                      value: guardianWork,
                    ),

                    const SizedBox(height: 24),

                    GuardiansDetailsColumnList(
                      titleKey: guardianAddressKey,
                      value: guardianAddress,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
