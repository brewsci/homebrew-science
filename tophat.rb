class Tophat < Formula
  desc "Spliced read mapper for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/tophat"
  url "http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.tar.gz"
  sha256 "37840b96f3219630082b15642c47f5ef95d14f6ee99c06a369b08b3d05684da5"
  # doi "10.1093/bioinformatics/btp120"
  # tag "bioinformatics"
  revision 1

  bottle do
    cellar :any
    sha256 "7c8cd03f1b5429a9458f23c3e89c1ca70a3bb66f86ea99830da78f6ca7df3060" => :el_capitan
    sha256 "9018f5952a79235bd3955522ac46ab0e94cbd489ec802f9295c24bd85ab204dd" => :yosemite
    sha256 "acd66232b41070f1fd1d5901a63f7306cbdb7793a7036c67b31a887c5be019dd" => :mavericks
    sha256 "a4aaf9f979f98b0c6e07cbf9eec6b334da8a08fb31e42170e6a5b46623300f1c" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "bowtie2"
  depends_on "bowtie" => :optional

  patch :p0, :DATA

  resource "test" do
    url "http://ccb.jhu.edu/software/tophat/downloads/test_data.tar.gz"
    sha256 "18840bd020dd23f4fe298d935c82f4b8ef7974de62ff755c21d7f88dc40054e1"
  end

  def install
    ENV.deparallelize
    ENV.append "LIBS", "-lboost_system-mt -lboost_thread-mt"

    resource("test").stage { (share/"test_data").install Dir["*"] }

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # clean up Python libraries from bin
    (libexec/"python").install bin/"intervaltree", bin/"sortedcontainers"
    (libexec/"bin").install bin/"tophat-fusion-post"
    (bin/"tophat-fusion-post").write_env_script libexec/"bin/tophat-fusion-post",
      :PYTHONPATH => libexec/"python"
  end

  test do
    system bin/"tophat", "-r", "20",
      share/"test_data/test_ref",
      share/"test_data/reads_1.fq", share/"test_data/reads_2.fq"
    assert_match "71.0%", File.read("tophat_out/align_summary.txt")
    system bin/"tophat-fusion-post", "--version"
  end
end
__END__
--- src/samtools-0.1.18/ksort.h.orig	2014-10-02 22:42:08.000000000 -0700
+++ src/samtools-0.1.18/ksort.h	2014-10-02 22:43:14.000000000 -0700
@@ -141,7 +141,7 @@
 			tmp = *l; *l = l[i]; l[i] = tmp; ks_heapadjust_##name(0, i, l); \
 		}																\
 	}																	\
-	inline void __ks_insertsort_##name(type_t *s, type_t *t)			\
+	static inline void __ks_insertsort_##name(type_t *s, type_t *t)			\
 	{																	\
 		type_t *i, *j, swap_tmp;										\
 		for (i = s + 1; i < t; ++i)										\
