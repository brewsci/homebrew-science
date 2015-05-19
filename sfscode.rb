class Sfscode < Formula
  desc "Population genetics simulator"
  homepage "http://sfscode.sourceforge.net/SFS_CODE/index/index.html"
  url "https://downloads.sourceforge.net/project/sfscode/sfscode/sfscode_20140719/sfscode_20140719.tgz"
  sha256 "1f69ed96e20f1453df2882ce78171b49cb3378b25538a3cacd18db00e07c979a"

  def install
    ENV.j1
    system "make", "CC=#{ENV.cc}", "EXEDIR=#{bin}"
    doc.install "doc/SFS_CODE_doc.pdf"
  end

  test do
    system bin/"sfs_code", "1", "1"
  end
end
