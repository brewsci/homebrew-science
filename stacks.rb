class Stacks < Formula
  desc "Pipeline for building loci from short-read sequences"
  homepage "https://creskolab.uoregon.edu/stacks/"
  # doi "10.1111/mec.12354"
  # tag "bioinformatics

  url "http://catchenlab.life.illinois.edu/stacks/source/stacks-1.46.tar.gz"
  sha256 "45a0725483dc0c0856ad6b1f918e65d91c1f0fe7d8bf209f76b93f85c29ea28a"
  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d091ee248b6b9c6c7b1373af824c1a2cf16830c64960463bfaaf8052b2b7b37a" => :el_capitan
    sha256 "b266a452669b9913a95c1df9663fbd850a62199f5a0e275d6caa6f59d82e7fb4" => :yosemite
    sha256 "2529637a4469483d6799290cde83d7415859db21a0f9a487b1ddc5d8c18cb4c8" => :mavericks
    sha256 "b6bba95f5d975d17490bef25e88d52f709bdff5278b92401354025cef1cf4e86" => :x86_64_linux
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
