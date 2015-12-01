class DataScienceToolbox < Formula
  # See also http://jeroenjanssens.com/2013/09/19/seven-command-line-tools-for-data-science.html
  homepage "https://github.com/jeroenjanssens/data-science-toolbox"
  version "077c94f"
  url "https://github.com/jeroenjanssens/data-science-toolbox/archive/#{version}.tar.gz"
  sha256 "5826e2b3c4dd735de3c071442ecd00c81944e84b65b00b684bbb0587ee634383"
  head "https://github.com/jeroenjanssens/data-science-toolbox.git"

  def install
    bin.install Dir["tools/*"]
    doc.install "README.md"
  end

  test do
    system "Rio -h 2>&1 |grep -q Rio"
  end
end
