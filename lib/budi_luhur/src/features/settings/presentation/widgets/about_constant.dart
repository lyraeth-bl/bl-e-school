class AboutUsContent {
  final String unit;
  final String tagline;
  final List<String> paragraphs;
  final List<AboutPoint> points;

  AboutUsContent({
    required this.unit,
    required this.tagline,
    required this.paragraphs,
    required this.points,
  });
}

class AboutPoint {
  final String title;
  final String description;

  AboutPoint(this.title, this.description);
}

final aboutSMA = AboutUsContent(
  unit: unitSMA,
  tagline: taglineSMA,
  paragraphs: [paragraph1SMA, paragraph2SMA, paragraph3SMA, paragraph4SMA],
  points: [
    AboutPoint(
      "Inovatif",
      "Kami mendorong siswa-siswa kami untuk selalu berinovasi dalam bidang studi mereka, baik itu dalam ilmu pengetahuan alam, ilmu pengetahuan sosial, maupun bahasa.",
    ),
    AboutPoint(
      "Kreatif",
      "Jurusan-jurusan kami memberikan ruang bagi kreativitas siswa dalam mengembangkan ide-ide baru dan solusi yang unik, baik dalam ranah ilmiah maupun humaniora.",
    ),
    AboutPoint(
      "Pengetahuan",
      "SMA Budi Luhur menjadi tempat yang ideal bagi siswa yang tertarik dan bersemangat dalam memperdalam pengetahuan dalam berbagai bidang ilmu pengetahuan alam, dan ilmu pengetahuan sosial.",
    ),
    AboutPoint(
      "Kolaboratif",
      "Kami mempromosikan kerja sama dan kolaborasi antar-siswa di berbagai jurusan untuk menciptakan pemahaman yang lebih mendalam tentang berbagai isu kompleks dalam masyarakat dan ilmu pengetahuan.",
    ),
    AboutPoint(
      "Profesionalisme",
      "Siswa kami dibimbing untuk menjadi profesional dalam bidang ilmu pengetahuan alam, dan ilmu pengetahuan sosial, siap untuk menghadapi tantangan dunia akademis dan profesional.",
    ),
    AboutPoint(
      "Keterampilan Multidisipliner",
      'SMA Budi Luhur memberikan siswa-siswa keterampilan lintas bidang yang dapat diterapkan dalam berbagai konteks ilmiah dan humaniora.',
    ),
    AboutPoint(
      "Prestasi",
      "Kami bangga dengan prestasi siswa-siswa kami dalam kompetisi-kompetisi baik tingkat lokal, nasional, maupun internasional di bidang-bidang studi yang mereka geluti.",
    ),
    AboutPoint(
      "Pengalaman Praktis",
      "Siswa-siswa kami mendapatkan pengalaman praktis melalui berbagai proyek dan magang di berbagai institusi terkait, mempersiapkan mereka untuk memasuki dunia akademis dan profesional dengan percaya diri.",
    ),
    AboutPoint(
      "Komitmen Terhadap Keunggulan",
      "SMA Budi Luhur berkomitmen untuk terus meningkatkan kualitas pendidikan di berbagai bidang studi guna menghasilkan lulusan-lulusan yang berkualitas dan siap bersaing di berbagai arena profesional dan akademis.",
    ),
  ],
);

final aboutSMK = AboutUsContent(
  unit: unitSMK,
  tagline: taglineSMK,
  paragraphs: [
    paragraph1SMK,
    paragraph2SMK,
    paragraph3SMK,
    paragraph4SMK,
    paragraph5SMK,
  ],
  points: [
    AboutPoint(
      "Inovatif",
      "Kami di SMK Budi Luhur mendorong siswa-siswa kami untuk selalu berinovasi dalam bidang Broadcast, Rekayasa Perangkat Lunak, dan Multimedia.",
    ),
    AboutPoint(
      "Kreatif",
      "Jurusan-jurusan kami memberikan ruang bagi kreativitas siswa dalam mengembangkan ide-ide baru dan solusi yang unik.",
    ),
    AboutPoint(
      "Teknologi",
      "SMK Budi Luhur menjadi tempat yang ideal bagi siswa yang tertarik dan bersemangat dalam mempelajari dan mengembangkan teknologi terkini di bidang Broadcast, Rekayasa Perangkat Lunak, dan Multimedia.",
    ),
    AboutPoint(
      "Kolaboratif",
      "Kami mempromosikan kerja sama dan kolaborasi antar-siswa di berbagai jurusan untuk menciptakan proyek-proyek yang berdampak.",
    ),
    AboutPoint(
      "Profesionalisme",
      "Siswa kami dibimbing untuk menjadi profesional dalam industri Broadcast, Rekayasa Perangkat Lunak, dan Multimedia, siap untuk menghadapi tantangan dunia kerja.",
    ),
    AboutPoint(
      "Keterampilan Multidisipliner",
      "SMK Budi Luhur memberikan siswa-siswa keterampilan lintas bidang yang dapat diterapkan dalam industri kreatif dan teknologi.",
    ),
    AboutPoint(
      "Prestasi",
      "Kami bangga dengan prestasi siswa-siswa kami dalam kompetisi-kompetisi baik tingkat lokal, nasional, maupun internasional di bidang Broadcast, Rekayasa Perangkat Lunak, dan Multimedia.",
    ),
    AboutPoint(
      "Peluang Karir",
      "Jurusan-jurusan kami menawarkan berbagai peluang karir di industri kreatif, teknologi, dan media massa.",
    ),
    AboutPoint(
      "Pengalaman Praktis",
      "Siswa-siswa kami mendapatkan pengalaman praktis melalui berbagai proyek dan magang di industri terkait, mempersiapkan mereka untuk masuk ke dunia kerja dengan percaya diri.",
    ),
    AboutPoint(
      "Komitmen Terhadap Keunggulan",
      "SMK Budi Luhur berkomitmen untuk terus meningkatkan kualitas pendidikan di bidang Broadcast, Rekayasa Perangkat Lunak, dan Multimedia guna menghasilkan lulusan-lulusan yang berkualitas dan siap bersaing di pasar kerja.",
    ),
  ],
);

const String unitSMA = "SMA Budi Luhur";
const String unitSMK = "SMK Budi Luhur";

const String taglineSMA =
    "Mengukir Masa Depan Melalui Kreativitas dan Pengetahuan";
const String taglineSMK =
    "Membangun Masa Depan Melalui Kreativitas dan Teknologi";

const String paragraph1SMA =
    "Selamat datang di SMA Budi Luhur, sebuah lembaga pendidikan yang menjadi wadah bagi kreativitas dan pengetahuan untuk membentuk masa depan yang cerah. Kami berkomitmen untuk memberikan pendidikan berkualitas.";
const String paragraph1SMK =
    "Selamat datang di SMK Budi Luhur, tempat di mana kreativitas bertemu dengan teknologi untuk membentuk masa depan yang cerah. Sebagai lembaga pendidikan yang berkomitmen untuk memberikan pendidikan berkualitas, SMK Budi Luhur menawarkan tiga jurusan unggulan yang siap mempersiapkan siswa untuk menjadi profesional di era digital ini.";

const String paragraph2SMA =
    "Ilmu Pengetahuan Alam (IPA) membawa siswa ke dalam dunia penelitian dan eksplorasi ilmiah, memungkinkan mereka untuk mendalami bidang-bidang seperti fisika, kimia, biologi, dan matematika. Dengan fasilitas laboratorium modern dan kurikulum yang terus berkembang, kami memastikan siswa kami dilengkapi dengan pengetahuan dan keterampilan yang dibutuhkan untuk sukses di dunia ilmiah.";
const String paragraph2SMK =
    "Jurusan Broadcast membawa siswa dalam petualangan dunia penyiaran, mengeksplorasi berbagai aspek produksi audio visual, jurnalisme, dan penyiaran. Dengan fasilitas modern dan kurikulum yang terus berkembang, siswa kami dibekali dengan keterampilan yang dibutuhkan untuk sukses di industri media yang dinamis.";

const String paragraph3SMA =
    "Ilmu Pengetahuan Sosial (IPS) membuka pintu bagi siswa untuk memahami kompleksitas masyarakat dan dunia politik, ekonomi, dan budaya. Dengan fokus pada sejarah, geografi, ekonomi, dan sosiologi, siswa kami diberdayakan untuk menganalisis dan memahami tantangan sosial yang dihadapi oleh masyarakat modern.";
const String paragraph3SMK =
    "Rekayasa Perangkat Lunak membuka pintu bagi para calon pengembang perangkat lunak handal. Dengan fokus pada pemrograman, desain perangkat lunak, dan pengujian, siswa kami diberdayakan untuk menciptakan solusi teknologi yang inovatif dan relevan dalam berbagai bidang, mulai dari aplikasi mobile hingga sistem informasi perusahaan.";

const String paragraph4SMA =
    "Di SMA Budi Luhur, kami tidak hanya berkomitmen untuk memberikan pendidikan berkualitas, tetapi juga membentuk karakter, kepemimpinan, dan etika kerja yang kokoh. Bersama-sama, kami menginspirasi siswa kami untuk meraih impian mereka dan menjadi pemimpin masa depan yang berpengaruh dalam bidangnya masing-masing. Selamat bergabung dengan kami dan mulailah perjalanan menuju kesuksesan yang tak terhingga!";
const String paragraph4SMK =
    "Jurusan Multimedia memadukan seni dan teknologi untuk menghasilkan karya-karya visual yang memukau. Dengan penekanan pada desain grafis, animasi, dan produksi konten digital, siswa kami merajut narasi visual yang menginspirasi dan memengaruhi. Dukungan dari instruktur berpengalaman dan peralatan mutakhir memastikan bahwa siswa kami siap untuk menghadapi tantangan industri kreatif global.";

const String paragraph5SMK =
    "Di SMK Budi Luhur, kami tidak hanya berkomitmen untuk memberikan pendidikan berkualitas, tetapi juga membentuk karakter, kepemimpinan, dan etika kerja yang kokoh. Bersama-sama, kami menginspirasi siswa kami untuk meraih impian mereka dan menjadi pemimpin masa depan yang berpengaruh dalam bidangnya masing-masing. Selamat bergabung dengan kami dan mulailah perjalanan menuju kesuksesan yang tak terhingga!";
