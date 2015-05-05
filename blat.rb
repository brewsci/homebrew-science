class Blat < Formula
  homepage "http://genome.ucsc.edu/FAQ/FAQblat.html"
  # doi "10.1101/gr.229202"
  # tag "bioinformatics"

  url "http://users.soe.ucsc.edu/~kent/src/blatSrc35.zip"
  sha1 "a2cae7407e512166bf7b1ed300db9be6649693bd"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "13852547459831466ac80ce6a39416c9381f32f7" => :yosemite
    sha1 "eb935f7f25e3bc7db280fa509e7fe0e1ced5b8dd" => :mavericks
    sha1 "910c75d17c0b5af2adca972825433f8ed0397ce9" => :mountain_lion
  end

  depends_on "libpng" => :build

  def install
    ENV.append_to_cflags "-I#{Formula["libpng"].opt_include}"
    bin.mkpath
    system "make", "MACHTYPE=#{OS.linux? ? "linux" : "darwin"}", "BINDIR=#{bin}"
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
