import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
abstract class Student with _$Student {
  const factory Student({
    @JsonKey(name: "NoKodeSekolah") required String noKodeSekolah,
    @JsonKey(name: "NoKodeKecamatan") required String noKodeKecamatan,
    @JsonKey(name: "NoKodeKabKot") required String noKodeKabupatenKota,
    @JsonKey(name: "NoKodeProvinsi") required String noKodeProvinsi,
    @JsonKey(name: "NIS") required String nis,
    @JsonKey(name: "NISN") String? nisn,
    @JsonKey(name: "Nama") String? nama,
    @JsonKey(name: "NamaPanggilan") required String namaPanggilan,
    @JsonKey(name: "TempLahir") required String tempatLahir,
    @JsonKey(name: "TglLahir") DateTime? tanggalLahir,
    @JsonKey(name: "JenisKelamin") String? jenisKelamin,
    @JsonKey(name: "Agama") String? agama,
    @JsonKey(name: "Kewarganegaraan") required String kewarganegaraan,
    @JsonKey(name: "Alamat") String? alamat,
    @JsonKey(name: "KodePos") String? kodePos,
    @JsonKey(name: "BertempatTinggalPada") String? bertempatTinggalPada,
    @JsonKey(name: "JarakKeSekolah") String? jarakKeSekolah,
    @JsonKey(name: "Telpon") String? noTelepon,
    @JsonKey(name: "DiterimaDiKelas") String? diTerimaDiKelas,
    @JsonKey(name: "NomorKelas") String? nomorKelas,
    @JsonKey(name: "TglDiTerima") required DateTime tanggalDiTerima,
    @JsonKey(name: "Semester") String? semester,
    @JsonKey(name: "NamaSekolahAsal") String? namaSekolahAsal,
    @JsonKey(name: "AlamatSekolahAsal") String? alamatSekolahAsal,
    @JsonKey(name: "TahunIjasah") String? tahunIjazah,
    @JsonKey(name: "NoIjasah") String? noIjazah,
    @JsonKey(name: "TanggalIjazah") required String tanggalIjazah,
    @JsonKey(name: "TahunSkhun") String? tahunSKHUN,
    @JsonKey(name: "NoSkhun") String? noSKHUN,
    @JsonKey(name: "PindahanDariSekolah") String? pindahanDariSekolah,
    @JsonKey(name: "DariTingkat") String? dariTingkat,
    @JsonKey(name: "DiterimaTanggal") String? diTerimaTanggal,
    @JsonKey(name: "NomorSuratKeteranganPindah")
    String? nomorSuratKeteranganPindah,
    @JsonKey(name: "AnakKe") String? anakKe,
    @JsonKey(name: "JumlahSaudaraKandung") required String jumlahSaudaraKandung,
    @JsonKey(name: "JumlahSaudaraTiri") required String jumlahSaudaraTiri,
    @JsonKey(name: "JumlahSaudaraAngkat") required String jumlahSaudaraAngkat,
    @JsonKey(name: "BahasaSeharihariDiRumah")
    required String bahasaSehariHariDiRumah,
    @JsonKey(name: "GolonganDarah") required String golonganDarah,
    @JsonKey(name: "StatKel") required String statusKeluarga,
    @JsonKey(name: "NamaAyah") String? namaAyah,
    @JsonKey(name: "NamaIbu") String? namaIbu,
    @JsonKey(name: "PendidikanTerakhirAyah")
    required String pendidikanTerakhirAyah,
    @JsonKey(name: "PendidikanTerakhirIbu")
    required String pendidikanTerakhirIbu,
    @JsonKey(name: "PekerjaanAyah") String? pekerjaanAyah,
    @JsonKey(name: "PekerjaanIbu") String? pekerjaanIbu,
    @JsonKey(name: "AlamatOrtu") String? alamatOrangTua,
    @JsonKey(name: "TelponOrtu") String? noTeleponOrangTua,
    @JsonKey(name: "NmWali") String? namaWali,
    @JsonKey(name: "AlamatWali") String? alamatWali,
    @JsonKey(name: "HubKelDgnWali") String? hubunganKeluargaDenganWali,
    @JsonKey(name: "PendidikanTerakhirWali") String? pendidikanTerakhirWali,
    @JsonKey(name: "TelpWali") String? noTeleponWali,
    @JsonKey(name: "PekerjaanWali") String? pekerjaanWali,
    @JsonKey(name: "Email") String? email,
    @JsonKey(name: "Password") String? passsword,
    @JsonKey(name: "KelasSaatIni") String? kelasSaatIni,
    @JsonKey(name: "NomorKelasSaatIni") String? noKelasSaatIni,
    @JsonKey(name: "TahunLulus") String? tahunLulus,
    @JsonKey(name: "NomorIjazahLulus") String? nomorIjazahLulus,
    @JsonKey(name: "MelanjutkanKeSekolah") String? melanjutkanKeSekolah,
    @JsonKey(name: "PindahSekolahKeSekolah")
    required String pindahSekolahKeSekolah,
    @JsonKey(name: "TingkatKelasYangDitinggalkan")
    String? tingkatKelasYangDiTinggalkan,
    @JsonKey(name: "AlasanKeluarSekolah") String? alasanKeluarSekolah,
    @JsonKey(name: "HariDanTanggalKeluarSekolah")
    String? hariDanTanggalKeluarSekolah,
    @JsonKey(name: "TinggiBadanSemesterGanjil")
    required String tinggiBadanSemesterGanjil,
    @JsonKey(name: "BeratBadanSemesterGanjil")
    required String beratBadanSemesterGanjil,
    @JsonKey(name: "PendengaranSemesterGanjil")
    String? pendengaranSemesterGanjil,
    @JsonKey(name: "PengelihatanSemesterGanjil")
    String? penglihatanSemesterGanjil,
    @JsonKey(name: "GigiSemesterGanjil") String? gigiSemesterGanjil,
    @JsonKey(name: "TinggiBadanSemesterGenap") String? tinggiBadanSemesterGenap,
    @JsonKey(name: "BeratBadanSemesterGenap") String? beratBadanSemesterGenap,
    @JsonKey(name: "PendengaranSemesterGenap") String? pendengaranSemesterGenap,
    @JsonKey(name: "PengelihatanSemesterGenap")
    String? penglihatanSemesterGenap,
    @JsonKey(name: "GigiSemesterGenap") String? gigiSemesterGenap,
    @JsonKey(name: "JenisPrestasiSainsSeniAtauOlahraga")
    String? jenisPrestasiSainsSeniAtauOlahraga,
    @JsonKey(
      name: "TingkatPrestasiSekolahKecamatanKabupatenProvinsiAtauNasional",
    )
    String? tingkatPrestasiSekolahKecamatanKabupatenProvinsiAtauNasional,
    @JsonKey(name: "NamaPrestasiLombaCerdasCermat")
    String? namaPrestasiLombaCerdasCermat,
    @JsonKey(name: "TahunPrestasiYangPernahDiraih")
    String? tahunPrestasiYangPernahDiraih,
    @JsonKey(
      name: "PenyelenggaraNamaPenyelenggaraAtauPanitiaKegiatanDariPrestasi",
    )
    String? penyelenggaraNamaPenyelenggaraAtauPanitiaKegiatanDariPrestasi,
    @JsonKey(name: "PeringkatAngkaPeringkatPrestasiYangPernahDiraih")
    String? peringkatAngkaPeringkatPrestasiYangPernahDiraih,
    @JsonKey(name: "JenisBeasiswaAnakBerprestasiAnakUnggulUnggulanAtauLainlain")
    String? jenisBeasiswaAnakBerprestasiAnakUnggulUnggulanAtauLainlain,
    @JsonKey(name: "KeteranganBeasiswaMuridBerprestasiTahun2022")
    String? keteranganBeasiswaMuridBerprestasiTahun2022,
    @JsonKey(name: "TahunMulaiTahunMulaiDiterimanyaBeasiswaOlehPesertaDidik")
    String? tahunMulaiTahunMulaiDiterimanyaBeasiswaOlehPesertaDidik,
    @JsonKey(
      name: "TahunSelesaiTahunSelesaiDiterimanyaBeasiswaOlehPesertaDidik",
    )
    String? tahunSelesaiTahunSelesaiDiterimanyaBeasiswaOlehPesertaDidik,
    @JsonKey(name: "SetelahSelesaiPendidikanMeninggalkanSekolah")
    String? setelahSelesaiPendidikanMeninggalkanSekolah,
    @JsonKey(name: "KeluarKarena") String? keluarKarena,
    @JsonKey(name: "TanggalKeluar") String? tanggalKeluar,
    @JsonKey(name: "AkhirPendidikan") String? akhirPendidikan,
    @JsonKey(name: "TamatBelajar") String? tamatBelajar,
    @JsonKey(name: "NomorIjazah") String? nomorIjazah,
    @JsonKey(name: "Aktif") String? aktif,
    @JsonKey(name: "StatNaik") required String statusNaik,
    @JsonKey(name: "UnameOrtu") required String usernameOrangTua,
    @JsonKey(name: "OrtuPass") String? passwordOrangTua,
    @JsonKey(name: "StatUjian") String? statusUjian,
    @JsonKey(name: "foto") String? profileImageUrl,
    @JsonKey(name: "unit") String? unit,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
