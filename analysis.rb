require 'formula'

class Analysis < Formula
  homepage "https://github.com/molpopgen/analysis"
  url 'http://molpopgen.org/software/analysis/analysis-0.8.4.tar.gz'
  sha1 '96d3e382216d34a0c2803087d6024323a8f20a2b'

  depends_on "boost"
  depends_on "gsl"
  depends_on "libsequence"

  # Automake looks for boost_regex, rather than boost_regex-mt
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"

    system "make"
    system "make install"
  end

  test do
    system 'gestimator 2>&1 |grep -q gestimator'
  end
end


__END__
--- analysis-0.8.4.orig/src/Makefile.am
+++ analysis-0.8.4/src/Makefile.am
@@ -77,7 +77,7 @@
 GSL=
 endif
 
-polydNdS_LDADD=-lboost_regex
+polydNdS_LDADD=-lboost_regex-mt
 
 if HAVE_STRSTREAM
 STRSTREAM = -DHAVE_STRSTREAM

--- analysis-0.8.4.orig/src/Makefile.in
+++ analysis-0.8.4/src/Makefile.in
@@ -330,7 +330,7 @@
 @HAVE_GSL_HEADERS_TRUE@rsq_LDADD = -lgsl -lgslcblas
 @HAVE_GSL_HEADERS_FALSE@GSL = 
 @HAVE_GSL_HEADERS_TRUE@GSL = -DHAVE_GSL
-polydNdS_LDADD = -lboost_regex
+polydNdS_LDADD = -lboost_regex-mt
 @HAVE_STRSTREAM_FALSE@STRSTREAM = 
 @HAVE_STRSTREAM_TRUE@STRSTREAM = -DHAVE_STRSTREAM
 @HAVE_SSTREAM_FALSE@SSTREAM = 
