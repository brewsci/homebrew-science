class Gfan < Formula
  desc "Computes Gröbner fans and tropical varieties"
  homepage "http://home.imf.au.dk/jensen/software/gfan/gfan.html"
  url "http://home.imf.au.dk/jensen/software/gfan/gfan0.5.tar.gz"
  sha256 "aaeabcf03aad9e426f1ace1f633ffa3200349600314063a7717c20a3e24db329"
  revision 1

  bottle :disable, "Test-bot cannot use the versioned gcc formulae"

  depends_on "cddlib"
  depends_on "gcc@5"
  depends_on "gmp"

  fails_with :clang
  fails_with :gcc => "6"

  patch :DATA

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "examples", "homepage", "testsuite"
  end

  test do
    system "#{bin}/gfan", "--help"
  end
end

__END__
diff --git a/app_minkowski.cpp b/app_minkowski.cpp
index d198fc3..939256a 100644
--- a/app_minkowski.cpp
+++ b/app_minkowski.cpp
@@ -160,7 +160,7 @@ public:
 	    //log0 fprintf(Stderr,"4");
 	    f.insert(c);
 	    //log0 fprintf(Stderr,"5\n");
-	    static int i;
+	    //static int i;
 	    //log0 fprintf(Stderr,"inserted:%i\n",++i);
 	  }
 	log1 fprintf(Stderr,"Resolving symmetries.\n");
