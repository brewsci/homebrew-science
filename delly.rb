require "formula"

class Delly < Formula
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.3.3.tar.gz"
  sha1 "b3537ee3276784356019fbb5c1b624d64f82469e"

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bamtools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.3.3/delly_v0.3.3_linux_x86_64bit"
    sha1 "50db4727dc5d163338d59b48f79d9f7041b2bfd9"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "${BAMTOOLS}/include", "#{Formula["bamtools"].opt_include}/bamtools"
      s.gsub! "${BAMTOOLS}/lib",     "#{Formula["bamtools"].opt_lib}"
      s.gsub! "${BOOST}",            "#{Formula["boost"].opt_prefix}"
      s.gsub! "${KSEQ}",             "#{Formula["htslib"].opt_include}/htslib"
    end

    if build.with? "binary"
      resource("linux-binary").stage { bin.install "delly_v0.3.3_linux_x86_64bit" => "delly" }

    else
      system "make", "CXX=#{ENV.cxx}"
      bin.install "src/delly"
    end

    share.install %W[src/somaticFilter.py src/populationFilter.py human.hg19.excl.tsv]
    doc.install "README.md"
  end

  test do
    system 'delly 2>&1 |grep -q delly'
  end
end
