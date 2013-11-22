require 'formula'

class Stacks < Formula
  homepage 'http://creskolab.uoregon.edu/stacks/'
  url 'http://creskolab.uoregon.edu/stacks/source/stacks-1.09.tar.gz'
  sha1 'a74d0877a1d24f481ba0bb1481d0259d5ebffe30'

  depends_on "google-sparsehash" => :recommended
  depends_on "samtools"          => :recommended

  fails_with :clang do
    build 500
    cause %q[error: 'tr1/unordered_map' file not found]
  end

  def patches
    # Fixes samtools dependency. Submitted to upstream:
    # https://groups.google.com/d/msg/stacks-users/0_zeYCGjexU/S0E4AcE4K3UJ
    DATA
  end

  def install
    # OpenMP doesn't yet work on OS X with Apple-provided compilers.
    args = ["--disable-dependency-tracking", "--disable-openmp", "--prefix=#{prefix}"]
    args << "--enable-sparsehash" if build.with? "google-sparsehash"

    if build.with? "samtools"
      samtools = Formula.factory("samtools")
      args += ["--enable-bam", "--with-bam-include-path=#{samtools.include}",
                               "--with-bam-lib-path=#{samtools.lib}"]
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      For instructions on setting up the web interface:
          #{prefix}/README

      The PHP and MySQL scripts have been installed to:
          #{share}
    EOS
  end

  test do
    system "#{bin}/ustacks", "--version"
  end
end
__END__
--- a/src/BamI.h
+++ b/src/BamI.h
@@ -29,7 +29,7 @@
 #ifdef HAVE_BAM
 
 #include "input.h"
-#include "bam.h"
+#include "bam/bam.h"
 
 class Bam: public Input {
     bamFile  bam_fh;
