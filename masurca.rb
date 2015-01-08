class Masurca < Formula
  homepage "http://www.genome.umd.edu/masurca.html"
  #doi "10.1093/bioinformatics/btt476"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA-2.3.2b.tar.gz"
  sha1 "3598f0b9580bd7518e09db173ada700b5e241b74"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "a23d26fbcd3de3975da85a3c3a7efba9c16845de" => :yosemite
    sha1 "480a1a8842f554b6e862f2073d791f3449877218" => :mavericks
    sha1 "6f76d1e0f4896e710f52a6f632c626766d1bf244" => :mountain_lion
  end

  fails_with :clang do
    build 600
    cause "No rule to make target `jellyfish/jellyfish.hpp', needed by `AS_OVL_overlap.o'. Stop."
  end

  depends_on "parallel"

  # Fix brew audit: Non-executables were installed to bin
  patch :DATA

  def install
    if OS.mac?
      # Fix error: 'operator()' is not a member of 'reallocator<basic_charb<reallocator<char> > >'
      inreplace "SuperReads/include/reallocators.hpp",
        "reallocator<T>::operator()",
        "reallocator<T>::realloc"

      # Fix ld: library not found for -lrt
      inreplace "SuperReads//Makefile.in", "-lrt", ""

      # Fix cp: CA/Linux-amd64/bin/*: No such file or directory
      inreplace "install.sh", "Linux-amd64", "Darwin-amd64"
    end

    ENV.deparallelize
    ENV["DEST"] = prefix
    system "./install.sh"

    # Conflicts with jellyfish
    rm Dir[lib/"libjellyfish*", lib/"pkgconfig/jellyfish-2.0.pc"]
    rm_r include/"jellyfish-2.1.3"

    # Conflicts with parallel
    rm bin/"parallel"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end

__END__
diff --git a/SuperReads/src/fix_unitigs.sh b/SuperReads/src/fix_unitigs.sh
index 9454bd8..844f71d 100755
--- a/SuperReads/src/fix_unitigs.sh
+++ b/SuperReads/src/fix_unitigs.sh
@@ -1,3 +1,4 @@
+#!/bin/sh
 #$1 -- PREFIX
 rm -f f_*
 rm -f *.out
diff --git a/SuperReads/src/run_ECR.sh b/SuperReads/src/run_ECR.sh
index c330c71..04bf972 100755
--- a/SuperReads/src/run_ECR.sh
+++ b/SuperReads/src/run_ECR.sh
@@ -1,3 +1,4 @@
+#!/bin/sh
 BEGIN_SCF=$1;
 END_SCF=$2;
 LAST_CKP=$3;
