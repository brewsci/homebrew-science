class Sequel < Formula
  desc "Improving the Accuracy of Genome Assemblies"
  homepage "https://bix.ucsd.edu/SEQuel/"
  # doi "10.1093/bioinformatics/bts219"
  # tag "bioinformatics"

  url "https://bix.ucsd.edu/SEQuel/download/SEQuel.v102.tar.gz"
  version "1.0.2"
  sha256 "7c2237eb0c99840eee1564e04eedf675219eadea882694b0d349caa38c2a2756"

  bottle do
    cellar :any_skip_relocation
    sha256 "421e6e93d10691e279d5aa6aaae3ed8c371cb23425aba82a520d891bab212282" => :el_capitan
    sha256 "0663e912b943010a8049de6e8896dcacb21b346e43ba7299244814aa1dd35713" => :yosemite
    sha256 "0663e912b943010a8049de6e8896dcacb21b346e43ba7299244814aa1dd35713" => :mavericks
    sha256 "bc786a7338217018cdab279d62da60fa449add5ea8a9f833094fb56e903ad94c" => :x86_64_linux
  end

  depends_on :java
  depends_on "blat"

  def install
    opts = "-Xmx12g"
    jar = "SEQuel.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "sequel", opts
    bin.install "blat_wrapper.pl"
    bin.install "prep.pl" => "sequel-prep.pl"
    doc.install "LICENSE", "README"
  end

  def caveats
    <<-EOS.undent
      The helper script prep.pl has been installed as sequel-prep.pl
    EOS
  end

  test do
    assert_match "refinement", shell_output("#{bin}/sequel -h 2>&1", 1)
  end
end
