require "formula"

class Blat < Formula
  homepage "http://genome.ucsc.edu/FAQ/FAQblat.html"
  url "http://users.soe.ucsc.edu/~kent/src/blatSrc35.zip"
  sha1 "a2cae7407e512166bf7b1ed300db9be6649693bd"

  depends_on "libpng" => :build

  def install
    bin.mkpath
    system "make", "MACHTYPE=darwin", "BINDIR=#{bin}"
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
    system "cat out.fa | grep spam"
  end
end
