class Stacks < Formula
  desc "Pipeline for building loci from short-read sequences"
  homepage "https://creskolab.uoregon.edu/stacks/"
  # doi "10.1111/mec.12354"
  # tag "bioinformatics

  url "http://catchenlab.life.illinois.edu/stacks/source/stacks-1.48.tar.gz"
  sha256 "e9f6251f5f609f9dd0bb1de17a51f69ce1a9af531548c4d2456a89783b1dcd1e"
  bottle do
    cellar :any_skip_relocation
    sha256 "1d7d006cc71540a086a2454c498f7021931d0d0815df9c9f1b8a352f16ac8939" => :high_sierra
    sha256 "e0a4cc082af2f9915ef594805e7fb30e47013f9b65c0bd9538ffcb688ef62119" => :sierra
    sha256 "aa17a67df77588f73f6f173a1acf5d5b5ab4e6fdd82d4ac6cd1be68379bf85af" => :el_capitan
  end

  depends_on "htslib"

  if MacOS.version < :mavericks
    depends_on "google-sparsehash" => [:build, :recommended, "c++11"]
  else
    depends_on "google-sparsehash" => [:build, :recommended]
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
    assert_match version.to_s, shell_output("#{bin}/ustacks --version 2>&1", 1)
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
