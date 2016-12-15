class LinksScaffolder < Formula
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.6.1/links_v1-6-1.tar.gz"
  version "1.6.1"
  sha256 "c4fa4f39dbee49c484521a80738758a39dc21b4a594d3e3fcf231d4decfdbe97"
  # doi "10.1186/s13742-015-0076-3"
  # tag "bioinformatics"

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
