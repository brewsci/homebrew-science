require 'formula'

class Analysis < Formula
  homepage 'http://molpopgen.org/software/lseqsoftware.html'
  url 'http://molpopgen.org/software/analysis/analysis-0.8.3.tar.gz'
  sha1 '83bb4607de2d8a8e8b95ea119da21cf354c77cd5'

  depends_on "boost"
  depends_on "gsl"
  depends_on "libsequence"

  def patches
    # Automake looks for boost_regex, rather than boost_regex-mt
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    system "make"
    system "make install"
  end

  def test
    system 'gestimator 2>&1 |grep -q gestimator'
  end
end


__END__
--- analysis-0.8.3.orig/src/Makefile.am
+++ analysis-0.8.3/src/Makefile.am
@@ -77,7 +77,7 @@
 GSL=
 endif
 
-polydNdS_LDADD=-lboost_regex
+polydNdS_LDADD=-lboost_regex-mt
 
 if HAVE_STRSTREAM
 STRSTREAM = -DHAVE_STRSTREAM

--- analysis-0.8.3.orig/src/Makefile.in
+++ analysis-0.8.3/src/Makefile.in
@@ -330,7 +330,7 @@
 @HAVE_GSL_HEADERS_TRUE@rsq_LDADD = -lgsl -lgslcblas
 @HAVE_GSL_HEADERS_FALSE@GSL = 
 @HAVE_GSL_HEADERS_TRUE@GSL = -DHAVE_GSL
-polydNdS_LDADD = -lboost_regex
+polydNdS_LDADD = -lboost_regex-mt
 @HAVE_STRSTREAM_FALSE@STRSTREAM = 
 @HAVE_STRSTREAM_TRUE@STRSTREAM = -DHAVE_STRSTREAM
 @HAVE_SSTREAM_FALSE@SSTREAM = 
