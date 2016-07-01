class Masurca < Formula
  desc "MaSuRCA: Maryland Super-Read Celera Assembler"
  homepage "http://www.genome.umd.edu/masurca.html"
  # doi "10.1093/bioinformatics/btt476"
  # tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA-2.3.2b.tar.gz"
  sha256 "837cb144d3dba206a778e88a06f2af67f2cc9ca4f5e6e97dd48ad4ac783aec70"

  bottle do
    sha256 "6f9032aa22d92cd3c2f182e6362bd56a6f1abfe44bc37905d09ed6319ee1f07e" => :yosemite
    sha256 "43e1abe110050b864613afa735bbca7870067ab91f434b7317d31063de2816c6" => :mavericks
    sha256 "be9c9590c280d56aba63e0c63244564c261efdc67cf35c4f46ff1b0022bfd3f6" => :mountain_lion
    sha256 "df11f02365e628aa983140acecdb80992187eb8b0dcc962cd1a47a1e63fa2399" => :x86_64_linux
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
    elsif OS.linux?
      # Fix libstdc++.so: undefined reference to `clock_gettime@GLIBC_2.17'
      inreplace "CA/src/c_make.as", %r{ARCH_LIB *= /usr/lib64 /usr/X11R6/lib64}, ""
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
