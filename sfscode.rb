class Sfscode < Formula
  desc "Population genetics simulator"
  homepage "https://sfscode.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sfscode/sfscode/sfscode_20150910/sfscode_20150910.tgz"
  sha256 "fee60d244bb0d756770a1e26e25683bc84aad13695ddfb3eab5d8f0c33312e7d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "65355ebf143d5ae2b9c7ca01bf830b451ce2348ecfb18af8d1f5beed96148f83" => :el_capitan
    sha256 "20c6de798168eb20dbadd36c133cb2c7d1f9f0834e577db37404d4924856dd42" => :yosemite
    sha256 "8bb471709ea95a2285c985a975e6500f56700b28e8e4dd3376098be12bc4cd5f" => :mavericks
  end

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}", "EXEDIR=#{bin}"
    doc.install "doc/SFS_CODE_doc.pdf"
  end

  test do
    system bin/"sfs_code", "1", "1"
  end
end
