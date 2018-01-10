class Blat < Formula
  desc "Genomic sequence search tool"
  homepage "https://genome.ucsc.edu/FAQ/FAQblat.html"
  # doi "10.1101/gr.229202"
  # tag "bioinformatics"

  url "http://hgwdev.cse.ucsc.edu/~kent/src/blatSrc36.zip"
  sha256 "4b0fff006c86dceb7428922bfb4f8625d78fd362d205df68e4ebba04742d2c71"

  bottle do
    cellar :any
    sha256 "af1ecf625bd23b8be03fff89e5f8056fd5bb33be39965b1f956848d6b90dc1d1" => :el_capitan
    sha256 "c4b95395dd2e649f34c82abe014464bfb17901e5e7abecb99dc46486dc852a52" => :yosemite
    sha256 "9580697a3ccc4ad36e83df0c24a89517769009d2904c5cc80b4b0f30a1646e6b" => :mavericks
    sha256 "a8600f4f95721ed78ab621ff4acefc92cd4fcddaa99604818a1e69258cb25548" => :x86_64_linux
  end

  depends_on "libpng" => :build
  depends_on :mysql => :build
  depends_on "openssl"

  def install
    ENV.append_to_cflags "-I#{Formula["libpng"].opt_include}"
    bin.mkpath
    system "make", "MACHTYPE=#{`uname -m`.chomp}", "BINDIR=#{bin}"
  end

  test do
    (testpath/"db.fa").write <<-EOF.undent
      >gi|5524211|gb|AAD44166.1| cytochrome b [Elephas maximus maximus]
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOF
    (testpath/"query.fa").write <<-EOF.undent
      >spam
      CLYTHIGRNIYYGSY
    EOF
    system "#{bin}/blat", "-prot", "db.fa", "query.fa", "out.fa"
    system "grep", "spam", "out.fa"
  end
end
