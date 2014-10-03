require 'formula'

class Tophat < Formula
  homepage 'http://ccb.jhu.edu/software/tophat'
  url 'http://ccb.jhu.edu/software/tophat/downloads/tophat-2.0.13.tar.gz'
  sha1 '71e8b63e42008ddd10e6324712c67e0e3428c378'

  depends_on 'boost'
  # Patch for OS X
  patch :p0, :DATA
  # bowtie or bowtie2 is required to execute tophat
  depends_on 'bowtie2' => :recommended

  def install
    # This can only build serially, otherwise it errors with no make target.
    ENV.deparallelize

    # Must add this to fix missing boost symbols. Autoconf doesn't include it.
    ENV.append 'LIBS', '-lboost_system-mt -lboost_thread-mt'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    # Run a simple test as described in
    # http://ccb.jhu.edu/software/tophat/tutorial.shtml#test
    curl *%w[-O http://ccb.jhu.edu/software/tophat/downloads/test_data.tar.gz]
    system *%w[tar xzf test_data.tar.gz]
    cd "test_data" do
      system "#{bin}/tophat -r 20 test_ref reads_1.fq reads_2.fq"
      File.read("tophat_out/align_summary.txt").include?("71.0% overall read mapping rate")
      assert_equal 0, $?.exitstatus
    end
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

