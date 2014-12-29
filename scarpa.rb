require "formula"

class Scarpa < Formula
  homepage "http://compbio.cs.toronto.edu/hapsembler/scarpa.html"
  #doi "10.1093/bioinformatics/bts716"
  #tag "bioinformatics"

  url "http://compbio.cs.toronto.edu/hapsembler/scarpa-0.241.tar.gz"
  sha1 "f238d8ea418951754b0f37aad7f09c9cf00fc909"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "515f728ee679f124b7429d384ac64aa46a5c00bf" => :yosemite
    sha1 "12a58085f99a35728046c57526474c5a4be92501" => :mavericks
    sha1 "0783d985dc71fab41182925f9d06625c21762041" => :mountain_lion
  end

  depends_on "lp_solve"

  def install
    rm Dir["liblpsolve55.*"]
    inreplace "Makefile", "liblpsolve55.a", "-llpsolve55"
    system "make"
    bin.install "bin/scarpa"
    doc.install "SCARPA.README"
  end

  test do
    system "#{bin}/scarpa", "--version"
  end
end
