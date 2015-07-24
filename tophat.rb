class Tophat < Formula
  homepage "http://ccb.jhu.edu/software/tophat"
  url "http://ccb.jhu.edu/software/tophat/downloads/tophat-2.0.14.tar.gz"
  sha256 "547c5c9d127cbf7d61bc73c4251ff98a07d57e59b3718666a18b58acfb8fcfbf"

  bottle do
    cellar :any
    sha256 "73296a1c7563a896cd80448424bd2406df4c28961d0ca4911b455602bfbfa829" => :yosemite
    sha256 "262b03db609f12566948e21ad2cf38c7b9c272650d707b49b1630577cf815979" => :mavericks
    sha256 "3735a997a3ff8e64534a1febb43b353b42e49c92414db86218f77626ce82c7da" => :mountain_lion
  end

  depends_on "boost" => :build
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
  end

  test do
    system bin/"tophat", "-r", "20",
      share/"test_data/test_ref",
      share/"test_data/reads_1.fq", share/"test_data/reads_2.fq"
    assert File.read("tophat_out/align_summary.txt").include?("71.0%")
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

