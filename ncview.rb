class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.6.tar.gz"
  sha256 "461738db29f9eb942a07e1ba4b57422aa3390d358f853bfd17c42a8c06f13543"

  bottle do
    sha256 "ccda1abb486e34f024c7efeb98e13523f0687c207c04bb76203e859ac57a9014" => :el_capitan
    sha256 "a118ed4638dc2ca0ddab8391d16354335ba95f1f9bbbcbfca545552895d65ca6" => :yosemite
    sha256 "20642b877a84345f987ecd0cc62921e43ed2475f09db2d5c9cb604ca0399f1e3" => :mavericks
  end

  depends_on :x11
  depends_on "netcdf"
  depends_on "udunits"

  # Disable a block in configure that tries to pass an RPATH to the compiler.
  # The code guesses wrong which causes the linking step to fail.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /Ncview #{version} /, shell_output("#{bin}/ncview -c 2>&1")
  end
end

__END__
--- ncview-2.1.5-orig/configure	2015-03-18 09:39:32.000000000 -0700
+++ ncview-2.1.5/configure	2015-05-29 13:44:28.000000000 -0700
@@ -5806,32 +5806,6 @@
 	exit -1
 fi
 
-#----------------------------------------------------------------------------------
-# Construct our RPATH flags.  Idea here is that we have LDFLAGS that might look,
-# for example, something like this:
-#	LIBS="-L/usr/local/lib -lnetcdf -L/home/pierce/lib -ludunits"
-# We want to convert this to -rpath flags suitable for the compiler, which would
-# have this format:
-#	"-Wl,-rpath,/usr/local/lib -Wl,-rpath,/home/pierce/lib"
-#
-# As a safety check, I only do this for the GNU compiler, as I don't know if this
-# is anything like correct syntax for other compilers.  Note that this *does* work
-# for the Intel icc compiler, but also that the icc compiler sets $ac_compiler_gnu
-# to "yes".  Go figure.
-#----------------------------------------------------------------------------------
-echo "ac_computer_gnu: $ac_compiler_gnu"
-if test x$ac_compiler_gnu = xyes; then
-	RPATH_FLAGS=""
-	for word in $UDUNITS2_LDFLAGS $NETCDF_LDFLAGS; do
-		if test `expr $word : -L/` -eq 3; then
-			#RPDIR=`expr substr $word 3 999`;
-			RPDIR=${word:2}
-			RPATH_FLAGS="$RPATH_FLAGS -Wl,-rpath,$RPDIR"
-		fi
-	done
-
-fi
-
 ac_config_files="$ac_config_files Makefile src/Makefile"
