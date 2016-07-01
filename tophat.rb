class Tophat < Formula
  desc "Spliced read mapper for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/tophat"
  url "http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.tar.gz"
  sha256 "37840b96f3219630082b15642c47f5ef95d14f6ee99c06a369b08b3d05684da5"
  # doi "10.1093/bioinformatics/btp120"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "186e8686503284e7ac3e0187388e5babaf1d5f07df07d6dbc27d91091becc505" => :el_capitan
    sha256 "f43d751a37fbe897315e450219392161becf97f445729d0dc007b8048687c3c7" => :yosemite
    sha256 "4f78eba798dbf5d23f237e87abdd5486b2fc874f6771fb0e1f8b6b1030cf37c1" => :mavericks
    sha256 "dedd0fa5a2cf7b3bd87431c9a3851c8f54231966a67406528501b804ff9ad5c0" => :x86_64_linux
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
