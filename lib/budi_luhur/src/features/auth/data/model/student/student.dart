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
    @JsonKey(name: "KodePos") required String kodePos,
    @JsonKey(name: "BertempatTinggalPada") required String bertempatTinggalPada,
    @JsonKey(name: "JarakKeSekolah") required String jarakKeSekolah,
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
    @JsonKey(name: "TahunSkhun") required String tahunSKHUN,
    @JsonKey(name: "NoSkhun") required String noSKHUN,
    @JsonKey(name: "PindahanDariSekolah") required String pindahanDariSekolah,
    @JsonKey(name: "DariTingkat") required String dariTingkat,
    @JsonKey(name: "DiterimaTanggal") required String diTerimaTanggal,
    @JsonKey(name: "NomorSuratKeteranganPindah")
    required String nomorSuratKeteranganPindah,
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
    @JsonKey(name: "NmWali") required String namaWali,
    @JsonKey(name: "AlamatWali") required String alamatWali,
    @JsonKey(name: "HubKelDgnWali") required String hubunganKeluargaDenganWali,
    @JsonKey(name: "PendidikanTerakhirWali")
    required String pendidikanTerakhirWali,
    @JsonKey(name: "TelpWali") required String noTeleponWali,
    @JsonKey(name: "PekerjaanWali") required String pekerjaanWali,
    @JsonKey(name: "Email") String? email,
    @JsonKey(name: "Password") String? passsword,
    @JsonKey(name: "KelasSaatIni") String? kelasSaatIni,
    @JsonKey(name: "NomorKelasSaatIni") String? noKelasSaatIni,
    @JsonKey(name: "TahunLulus") required String tahunLulus,
    @JsonKey(name: "NomorIjazahLulus") required String nomorIjazahLulus,
    @JsonKey(name: "MelanjutkanKeSekolah") required String melanjutkanKeSekolah,
    @JsonKey(name: "PindahSekolahKeSekolah")
    required String pindahSekolahKeSekolah,
    @JsonKey(name: "TingkatKelasYangDitinggalkan")
    required String tingkatKelasYangDiTinggalkan,
    @JsonKey(name: "AlasanKeluarSekolah") required String alasanKeluarSekolah,
    @JsonKey(name: "HariDanTanggalKeluarSekolah")
    required String hariDanTanggalKeluarSekolah,
    @JsonKey(name: "TinggiBadanSemesterGanjil")
    required String tinggiBadanSemesterGanjil,
    @JsonKey(name: "BeratBadanSemesterGanjil")
    required String beratBadanSemesterGanjil,
    @JsonKey(name: "PendengaranSemesterGanjil")
    required String pendengaranSemesterGanjil,
    @JsonKey(name: "PengelihatanSemesterGanjil")
    required String penglihatanSemesterGanjil,
    @JsonKey(name: "GigiSemesterGanjil") required String gigiSemesterGanjil,
    @JsonKey(name: "TinggiBadanSemesterGenap")
    required String tinggiBadanSemesterGenap,
    @JsonKey(name: "BeratBadanSemesterGenap")
    required String beratBadanSemesterGenap,
    @JsonKey(name: "PendengaranSemesterGenap")
    required String pendengaranSemesterGenap,
    @JsonKey(name: "PengelihatanSemesterGenap")
    required String penglihatanSemesterGenap,
    @JsonKey(name: "GigiSemesterGenap") required String gigiSemesterGenap,
    @JsonKey(name: "JenisPrestasiSainsSeniAtauOlahraga")
    required String jenisPrestasiSainsSeniAtauOlahraga,
    @JsonKey(
      name: "TingkatPrestasiSekolahKecamatanKabupatenProvinsiAtauNasional",
    )
    required String
    tingkatPrestasiSekolahKecamatanKabupatenProvinsiAtauNasional,
    @JsonKey(name: "NamaPrestasiLombaCerdasCermat")
    required String namaPrestasiLombaCerdasCermat,
    @JsonKey(name: "TahunPrestasiYangPernahDiraih")
    required String tahunPrestasiYangPernahDiraih,
    @JsonKey(
      name: "PenyelenggaraNamaPenyelenggaraAtauPanitiaKegiatanDariPrestasi",
    )
    required String
    penyelenggaraNamaPenyelenggaraAtauPanitiaKegiatanDariPrestasi,
    @JsonKey(name: "PeringkatAngkaPeringkatPrestasiYangPernahDiraih")
    required String peringkatAngkaPeringkatPrestasiYangPernahDiraih,
    @JsonKey(name: "JenisBeasiswaAnakBerprestasiAnakUnggulUnggulanAtauLainlain")
    required String jenisBeasiswaAnakBerprestasiAnakUnggulUnggulanAtauLainlain,
    @JsonKey(name: "KeteranganBeasiswaMuridBerprestasiTahun2022")
    required String keteranganBeasiswaMuridBerprestasiTahun2022,
    @JsonKey(name: "TahunMulaiTahunMulaiDiterimanyaBeasiswaOlehPesertaDidik")
    required String tahunMulaiTahunMulaiDiterimanyaBeasiswaOlehPesertaDidik,
    @JsonKey(
      name: "TahunSelesaiTahunSelesaiDiterimanyaBeasiswaOlehPesertaDidik",
    )
    required String tahunSelesaiTahunSelesaiDiterimanyaBeasiswaOlehPesertaDidik,
    @JsonKey(name: "SetelahSelesaiPendidikanMeninggalkanSekolah")
    required String setelahSelesaiPendidikanMeninggalkanSekolah,
    @JsonKey(name: "KeluarKarena") required String keluarKarena,
    @JsonKey(name: "TanggalKeluar") required String tanggalKeluar,
    @JsonKey(name: "AkhirPendidikan") required String akhirPendidikan,
    @JsonKey(name: "TamatBelajar") required String tamatBelajar,
    @JsonKey(name: "NomorIjazah") required String nomorIjazah,
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
