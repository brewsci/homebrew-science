class DazzDb < Formula
  desc "DAZZ_DB: The Dazzler Data Base"
  homepage "https://github.com/thegenemyers/DAZZ_DB"
  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DAZZ_DB/archive/V1.0.tar.gz"
  sha256 "ae7a71b71925dd5a1fd4026ca7462a70cb8ade9d3afd5cdeef0f1bd11b9c9105"

  head "https://github.com/thegenemyers/DAZZ_DB.git"

  def install
    system "make"
    bin.install %w[Catrack DAM2fasta DB2fasta DB2quiva DBdust DBrm DBshow DBsplit DBstats fasta2DAM fasta2DB quiva2DB simulator]
    doc.install "README"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/fasta2DB 2>&1", 1)
  end
end
