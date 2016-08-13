class Sfscode < Formula
  desc "Population genetics simulator"
  homepage "http://sfscode.sourceforge.net/SFS_CODE/index/index.html"
  url "https://downloads.sourceforge.net/project/sfscode/sfscode/sfscode_20140719/sfscode_20140719.tgz"
  sha256 "1f69ed96e20f1453df2882ce78171b49cb3378b25538a3cacd18db00e07c979a"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "65355ebf143d5ae2b9c7ca01bf830b451ce2348ecfb18af8d1f5beed96148f83" => :el_capitan
    sha256 "20c6de798168eb20dbadd36c133cb2c7d1f9f0834e577db37404d4924856dd42" => :yosemite
    sha256 "8bb471709ea95a2285c985a975e6500f56700b28e8e4dd3376098be12bc4cd5f" => :mavericks
  end

  def install
    ENV.j1
    system "make", "CC=#{ENV.cc}", "EXEDIR=#{bin}"
    doc.install "doc/SFS_CODE_doc.pdf"
  end

  test do
    system bin/"sfs_code", "1", "1"
  end
end
