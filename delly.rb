require "formula"

class Delly < Formula
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.5.6.tar.gz"
  sha1 "c23c079da1e2617a56b34ba543b765425b9b1533"

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bamtools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.5.6/delly_v0.5.6_CentOS5.4_x86_64bit"
    sha1 "6642bd407d0982a6a6d913e61ce2b50e8855bad5"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "${BAMTOOLS_ROOT}/include", "#{Formula["bamtools"].opt_include}/bamtools"
      s.gsub! "${BAMTOOLS_ROOT}/lib",     "#{Formula["bamtools"].opt_lib}"
      s.gsub! "${BOOST_ROOT}",            "#{Formula["boost"].opt_prefix}"
      s.gsub! "${SEQTK_ROOT}",            "#{Formula["htslib"].opt_include}/htslib"
    end

    if build.with? "binary"
      resource("linux-binary").stage { bin.install "delly_v0.5.6_CentOS5.4_x86_64bit" => "delly" }

    else
      system "make", "CXX=#{ENV.cxx}"
      bin.install "src/delly"
    end

    share.install %W[python/somaticFilter.py python/populationFilter.py human.hg19.excl.tsv]
    doc.install "README.md"
  end

  test do
    system 'delly 2>&1 |grep -q delly'
  end
end
