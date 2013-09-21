require 'formula'

class Stacks < Formula
  homepage 'http://creskolab.uoregon.edu/stacks/'
  url 'http://creskolab.uoregon.edu/stacks/source/stacks-1.06.tar.gz'
  sha1 '5294404195d223b3dcb48f72cdd64b598eaae029'

  depends_on "google-sparsehash" => :recommended
  depends_on "samtools"          => :recommended

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
diff --git a/src/Bam.h b/src/Bam.h
index dce20d8..9d077eb 100644
--- a/src/Bam.h
+++ b/src/Bam.h
@@ -29,7 +29,7 @@
 #ifdef HAVE_BAM
 
 #include "input.h"
-#include "bam.h"
+#include "bam/bam.h"
 
 class Bam: public Input {
     bamFile  bam_fh;
