class Clark < Formula
  homepage "http://clark.cs.ucr.edu/"
  # tag "bioinformatics"
  # doi "10.1186/s12864-015-1419-2"

  url "http://clark.cs.ucr.edu/Download/CLARKV1.1.2.tar.gz"
  sha256 "d97936a6c3c9215f659296a665c662de3f9406dcc957f8f58b313edd2c52f371"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "2bcb2cef51f100e4c1f68d09daf9ec1fd142d619fd45aeb6ff0daf9433366196" => :yosemite
    sha256 "1b2ee269e30d182741088bacea70e08efbaf7d8fb686fcfa70b4180f5982e304" => :mavericks
    sha256 "0170bdb097e001e805d0764b7f69b51409e4e1df97f4a89bd9688c6a40e9afe1" => :mountain_lion
  end

  needs :openmp

  def install
    system "sh", "install.sh"
    bin.install Dir["exe/*"]
    doc.install "README.txt", "LICENSE_GNU_GPL.txt"
  end

  test do
    assert_match "k-spectrum", shell_output("CLARK 2>&1", 255)
  end
end
