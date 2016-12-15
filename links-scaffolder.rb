class LinksScaffolder < Formula
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.8.4/links_v1-8-4.tar.gz"
  version "1.8.4"
  sha256 "9256bc26669a900fd6d8bfce07c69464ca9f45fb54ce89d145c54b732f2407a0"
  # doi "10.1186/s13742-015-0076-3"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "96396e8453cb24a5e293970d999b00f2a5b6c869893ffc17a190c7ab0b7204b1" => :sierra
    sha256 "a1ba232d1ad697f9a3f08514c42f58b05681d61bff06e5ffcdbb888716f3c272" => :el_capitan
    sha256 "2d1c3a69a6da22e7ccd99f9adc8ada0ab508a0db182a5fd34d47ea30db30c503" => :yosemite
    sha256 "89e8147fbf830dcd1b6bda90c260b96ccf38212c73a0336020174e54f14f730e" => :x86_64_linux
  end

  depends_on "swig" => :build
  depends_on "perl"

  def install
    if OS.mac?
      # Fix error: no known conversion from 'size_t' (aka 'unsigned long') to 'uint64_t &' (aka 'unsigned long long &')
      cd "lib/bloomfilter" do
        inreplace ["BloomFilter.hpp", "RollingHash.h", "RollingHashIterator.h", "swig/BloomFilter.i"],
          "size_t", "uint64_t"
      end
    end
    cd "lib/bloomfilter/swig" do
      so = OS.mac? ? "bundle" : "so"
      perl = Dir[Formula["perl"].lib/"perl5/*/*/CORE"][0]
      cxxflags = (ENV.cxxflags || "").split
      system "swig", "-Wall", "-c++", "-perl5", "BloomFilter.i"
      system ENV.cxx, *cxxflags, "-c", "-fPIC", "-I#{perl}", "BloomFilter_wrap.cxx"
      system ENV.cxx, *cxxflags, "-shared", "-o", "BloomFilter.#{so}", "BloomFilter_wrap.o", "-L#{perl}", "-lperl"
      libexec.install "BloomFilter.pm", "BloomFilter.#{so}"
    end

    inreplace "LINKS", "/usr/bin/perl", "/usr/bin/env perl"
    inreplace "LINKS", "$FindBin::Bin/./lib/bloomfilter/swig", "$FindBin::RealBin/../libexec"
    bin.install "LINKS"
    chmod 0644, "LINKS-readme.txt"
    doc.install "LINKS-readme.txt"
    doc.install "LINKS-readme.pdf"
    prefix.install "test"
    prefix.install "tools"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/LINKS", 255)
  end
end
