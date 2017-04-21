class Stacks < Formula
  desc "Pipeline for building loci from short-read sequences"
  homepage "https://creskolab.uoregon.edu/stacks/"
  # doi "10.1111/mec.12354"
  # tag "bioinformatics

  url "http://catchenlab.life.illinois.edu/stacks/source/stacks-1.46.tar.gz"
  sha256 "45a0725483dc0c0856ad6b1f918e65d91c1f0fe7d8bf209f76b93f85c29ea28a"
  bottle do
    cellar :any_skip_relocation
    sha256 "0cf5db2f8aa026d172d3b15dc219febab62361b5257890be02be6b5d216545a8" => :sierra
    sha256 "f333436bf678e1122276b4d3de7c47c399cf26c4ae120f3cfbc1be550a5db06b" => :el_capitan
    sha256 "99474e4f01966e2faf92c43cb20db1fe451fbe5d57a0c9d2b6c4a77dfd85e673" => :yosemite
    sha256 "954189eeaf39bd6a2ed66f1f3b842762bf112aa4f93b28f0ed42aacf9eef4da1" => :x86_64_linux
  end

  depends_on "htslib"

  if MacOS.version < :mavericks
    depends_on "google-sparsehash" => [:recommended, "c++11"]
  else
    depends_on "google-sparsehash" => :recommended
  end

  # Fix error: 'tr1/functional' file not found
  patch :DATA

  needs :cxx11
  fails_with :gcc => "4.8"

  def install
    ENV.libcxx

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-sparsehash" if build.with? "google-sparsehash"
    args << " --disable-openmp" if build.without? "openmp"

    system "./configure", *args
    system "make"
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
diff --git a/src/DNANSeq.h b/src/DNANSeq.h
index 62b5d91..9c2ff12 100644
--- a/src/DNANSeq.h
+++ b/src/DNANSeq.h
@@ -25,7 +25,7 @@
 #include <limits.h>

 #include <functional> //std::hash
-#ifdef HAVE_SPARSEHASH
+#if 0
 #include <tr1/functional>
 #endif

@@ -115,7 +115,7 @@ struct hash<DNANSeq> {
     }
 };

-#ifdef HAVE_SPARSEHASH
+#if 0
 namespace tr1 {
 template<>
 struct hash<DNANSeq> {
