require "formula"

class Delly < Formula
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.5.5.tar.gz"
  sha1 "58e21befcfc16a350102f72e84eaab0f08119f29"

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bamtools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.5.5/delly_v0.5.5_CentOS5.4_x86_64bit"
    sha1 "5ab782a2c917042f37b00ca9c3fad0eeb8d8650e"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "${BAMTOOLS_ROOT}/include", "#{Formula["bamtools"].opt_include}/bamtools"
      s.gsub! "${BAMTOOLS_ROOT}/lib",     "#{Formula["bamtools"].opt_lib}"
      s.gsub! "${BOOST_ROOT}",            "#{Formula["boost"].opt_prefix}"
      s.gsub! "${SEQTK_ROOT}",            "#{Formula["htslib"].opt_include}/htslib"
    end

    if build.with? "binary"
      resource("linux-binary").stage { bin.install "delly_v0.5.5_CentOS5.4_x86_64bit" => "delly" }

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
