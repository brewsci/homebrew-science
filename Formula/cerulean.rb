class Cerulean < Formula
  desc "Extend contigs assembled using short reads using long reads"
  homepage "https://sourceforge.net/projects/ceruleanassembler/"
  # doi "10.1007/978-3-642-40453-5_27"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/ceruleanassembler/Cerulean_v_0_1.tar.gz"
  sha256 "b6b9046fb1cf9980a169ccfe1a57c1060c6afbbe12e6b201eb8c47be0849b688"

  bottle do
    cellar :any_skip_relocation
    sha256 "728bc5f34edfe6119834b3686351632ff011ca0c14582bd119b1712e78677edd" => :x86_64_linux
  end

  depends_on "abyss" => :recommended
  depends_on "numpy"

  def install
    doc.install "README"
    libexec.install Dir["src/*"]
    prefix.install "data"
  end

  test do
    system "python", "#{libexec}/Cerulean.py", "-h"
  end
end
