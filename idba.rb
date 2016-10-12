class Idba < Formula
  desc "Iterative De Bruijn Graph De Novo Assembler for sequence assembly"
  homepage "http://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  # doi "10.1093/bioinformatics/bts174"
  # tag "bioinformatics"

  url "https://github.com/loneknightpy/idba/archive/1.1.3.tar.gz"
  sha256 "6b1746a29884f4fa17b110d94d9ead677ab5557c084a93b16b6a043dbb148709"

  bottle do
    cellar :any
    sha256 "9ce6a82cee5d4a891f1dfe38a9a6a9d2a409f9fe9d2193c54cce498a53897eef" => :yosemite
    sha256 "066ff8986d811ee9190db54c6fbfb77fde054ef0c096800438fa2338a4badec6" => :mavericks
    sha256 "10bf4be36d3797c48f58580078ee2d197227cdb297f5b2ba826590fd4ba92983" => :mountain_lion
    sha256 "b388e1426c8c92637246a8dd21487ff0b4d31c4f15073892211be12e65a3c9eb" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :openmp

  resource "lacto-genus" do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hku-idba/lacto-genus.tar.gz"
    sha256 "b2496e8b9050c4448057214b9902a5d4db9e0069d480e65af029d53ce167a929"
  end

  def install
    system "aclocal"
    system "autoconf"
    system "automake", "--add-missing"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    # system "make", "install"  # currently does not install everything
    bin.install Dir["bin/idba*"].select { |x| File.executable? x }
    libexec.install Dir["bin/*"].select { |x| File.executable? x }
    doc.install %w[AUTHORS ChangeLog NEWS README.md]
  end

  test do
    system "#{bin}/idba_ud 2>&1 |grep IDBA-UD"
    resource("lacto-genus").stage testpath
    cd testpath do
      system libexec/"sim_reads", "220668.fa", "220668.reads-10", "--paired", "--depth", "10"
      system bin/"idba", "-r", "220668.reads-10"
    end
  end
end
