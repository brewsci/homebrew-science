require "formula"

class Delly < Formula
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.6.1.tar.gz"
  sha1 "7f01feb98ca8f7f68422762336ef36b4802c5a71"

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bamtools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary-0.6.1" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.6.1/delly_v0.6.1_CentOS5.4_x86_64bit"
    sha1 "5941f6eaa528f5ab7d83e4ffa8c0c90ff01cb674"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "${BAMTOOLS_ROOT}/include", "#{Formula["bamtools"].opt_include}/bamtools"
      s.gsub! "${BAMTOOLS_ROOT}/lib",     "#{Formula["bamtools"].opt_lib}"
      s.gsub! "${BOOST_ROOT}",            "#{Formula["boost"].opt_prefix}"
      s.gsub! "${SEQTK_ROOT}",            "#{Formula["htslib"].opt_include}/htslib"
      s.gsub! ".htslib .bamtools",        ""
    end

    if build.with? "binary"
      resource("linux-binary-0.6.1").stage { bin.install "delly_v0.6.1_CentOS5.4_x86_64bit" => "delly" }

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
