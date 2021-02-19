class DazzDb < Formula
  desc ": The Dazzler Data Base"
  homepage "https://github.com/thegenemyers/DAZZ_DB"
  url "https://github.com/thegenemyers/DAZZ_DB/archive/V1.0.tar.gz"
  sha256 "ae7a71b71925dd5a1fd4026ca7462a70cb8ade9d3afd5cdeef0f1bd11b9c9105"
  head "https://github.com/thegenemyers/DAZZ_DB.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, yosemite:      "9d250aca96917cb8a33d0329a397468ce6e58b0a9fb3536741a6291cee646925"
    sha256 cellar: :any, mavericks:     "8ad2de72d4d6f0a1a51c65acec52d3ed220a96ffa804e1c4942667caf872dcb3"
    sha256 cellar: :any, mountain_lion: "5a911e0c31bb18d467455c196bf74a1f709fa5d538572489ba5d033921a5536a"
    sha256 cellar: :any, x86_64_linux:  "6462f032be26bb06786cf87f652f2e545e4c3af06b25fb1b753a1eaa3f7c5eec"
  end

  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  def install
    system "make"
    bin.install %w[Catrack DAM2fasta DB2fasta DB2quiva DBdust DBrm DBshow DBsplit DBstats fasta2DAM fasta2DB
                   quiva2DB simulator]
    doc.install "README"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/fasta2DB 2>&1", 1)
  end
end
