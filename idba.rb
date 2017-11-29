class Idba < Formula
  desc "Iterative De Bruijn Graph De Novo Assembler for sequence assembly"
  homepage "https://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  # doi "10.1093/bioinformatics/bts174"
  # tag "bioinformatics"

  url "https://github.com/loneknightpy/idba/archive/1.1.3.tar.gz"
  sha256 "6b1746a29884f4fa17b110d94d9ead677ab5557c084a93b16b6a043dbb148709"

  bottle do
    cellar :any
    sha256 "f62d93ef0fc8c4bac79c87fae6469a7dedf205c4ae28ad6e4a55af2605139ed0" => :sierra
    sha256 "122697a0e489f1fe328ff5a8338704c3ada8e8f18f6f5509a43e1003485490ab" => :el_capitan
    sha256 "3eea0748c64e69e9be231f3044edb52b6b34f316445b16f9ed4c3b6b2cbee18b" => :yosemite
    sha256 "e8c0a07b4d537f67cf81fd69ab4fb821c7757232cb4e382772ccca09cec67c0c" => :x86_64_linux
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
