class LinuxRequirement < Requirement
  fatal true
  satisfy OS.linux?
  def message
    "This software is only supported on Linux. Mac OS is missing the required function mremap."
  end
end

class Masurca < Formula
  desc "MaSuRCA: Maryland Super-Read Celera Assembler"
  homepage "http://www.genome.umd.edu/masurca.html"
  url "https://raw.githubusercontent.com/helios/bio-docker/master/stringtie/1.2.1/MaSuRCA-3.1.3.tar.gz"
  sha256 "0708bc6ec5a61e177533b290380d2c3de598e49f1da640df9cd88fb538913e48"
  # doi "10.1093/bioinformatics/btt476"
  # tag "bioinformatics"

  bottle do
    sha256 "6f9032aa22d92cd3c2f182e6362bd56a6f1abfe44bc37905d09ed6319ee1f07e" => :yosemite
    sha256 "43e1abe110050b864613afa735bbca7870067ab91f434b7317d31063de2816c6" => :mavericks
    sha256 "be9c9590c280d56aba63e0c63244564c261efdc67cf35c4f46ff1b0022bfd3f6" => :mountain_lion
    sha256 "df11f02365e628aa983140acecdb80992187eb8b0dcc962cd1a47a1e63fa2399" => :x86_64_linux
  end

  # A fix for Mac OS is welcome.
  # sort.cc:62:75: error: 'mremap' was not declared in this scope
  depends_on LinuxRequirement

  fails_with :clang do
    build 703
    cause "n50.cc:105:51: error: no member named 'ceil' in namespace 'std'"
  end

  fails_with :gcc => "6" do
    cause "n50.cc:105:51: error: no member named 'ceil' in namespace 'std'"
  end

  depends_on "parallel"

  def install
    if OS.mac?
      # Fix cp: CA/Linux-amd64/bin/*: No such file or directory
      inreplace "install.sh", "Linux-amd64", "Darwin-amd64"
    elsif OS.linux?
      # Fix libstdc++.so: undefined reference to `clock_gettime@GLIBC_2.17'
      inreplace "CA/src/c_make.as", %r{ARCH_LIB *= /usr/lib64 /usr/X11R6/lib64}, ""
    end

    ENV.deparallelize
    ENV["DEST"] = prefix
    system "./install.sh"

    # Conflicts with SOAPdenovo
    rm [bin/"SOAPdenovo-63mer", bin/"SOAPdenovo-127mer"]

    # Conflicts with jellyfish
    rm bin/"jellyfish"
    rm Dir[lib/"libjellyfish*", lib/"pkgconfig/jellyfish-2.0.pc"]
    rm_r include/"jellyfish-1"
    rm man1/"jellyfish.1"

    # Conflicts with parallel
    rm bin/"parallel"

    # Conflicts with samtools
    rm bin/"samtools"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
