class Blat < Formula
  homepage "http://genome.ucsc.edu/FAQ/FAQblat.html"
  # doi "10.1101/gr.229202"
  # tag "bioinformatics"

  url "http://users.soe.ucsc.edu/~kent/src/blatSrc35.zip"
  sha256 "06d9bcf114ec4a4b21fef0540a0532556b6602322a5a2b33f159dc939ae53620"

  bottle do
    cellar :any
    revision 1
    sha256 "7e1ae73487db28bca75585482ccf50f206468f714365730af8dae7cc1c892ef2" => :yosemite
    sha256 "fc541ee6ebb3f895b2e9700431325687c9a95bf2ab55a0d6fcafa95110d30c29" => :mavericks
    sha256 "c21f79a061ee6d0594f1f35b743e99e84c6d1a604f34c738ea32370a1234864b" => :mountain_lion
  end

  depends_on "libpng" => :build

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
