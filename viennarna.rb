require 'formula'

class Viennarna < Formula
  homepage 'http://www.tbi.univie.ac.at/~ivo/RNA/'
  url 'http://www.tbi.univie.ac.at/~ronny/RNA/ViennaRNA-2.0.7.tar.gz'
  sha1 'eced95b1cb5d09acb4dbd372a2b11ac48e19344b'

  option 'with-perl', 'build and install Perl interfaces'

  def install
    ENV['ARCHFLAGS'] = "-arch x86_64"
    args = ["./configure", "--disable-debug", "--disable-dependency-tracking",
                      "--prefix=#{prefix}", "--disable-openmp"]
    args << '--without-perl' unless build.include? 'with-perl'
    system(*args)
    system "make install"
  end

  def patches
    DATA
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ViennaRNA`.
    system "echo 'GGGGCUAUAGCUCAGCUGGGAGAGCGCUUGCAUGGCAUGCAAGAGGUCAGCGGUUCGAUCCCGCUUAGCUCCACCA' | RNAFold"
  end
end

__END__
--- ViennaRNA-2.0.7/Makefile.in	2012-06-15 10:39:46.000000000 +0900
+++ ViennaRNA-2.0.7/Makefile.in.new	2012-06-15 10:26:15.000000000 +0900
@@ -830,8 +830,7 @@

 info-am:

-install-data-am: install-dist_docDATA install-dist_docdir_htmlDATA \
-	install-docDATA install-docdir_htmlDATA install-pkgconfigDATA \
+install-data-am: 	install-docDATA install-docdir_htmlDATA install-pkgconfigDATA \
	install-pkgdataDATA

 install-dvi: install-dvi-recursive
