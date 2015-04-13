class Prodigal < Formula
  homepage "http://prodigal.ornl.gov/"
  head "https://github.com/hyattpd/Prodigal.git"
  #doi "10.1186/1471-2105-11-119"
  #tag "bioinformatics"

  url "https://github.com/hyattpd/Prodigal/archive/v2.6.2.tar.gz"
  sha256 "0409e95dc9fd8df57aff0fe6c9da6895dab5b5a90a28fb2fcdbd52f31c581a55"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "58b6b6ea89bc542585104fba63ffd5b9a1a5a52b" => :yosemite
    sha1 "cad820e17038130c8e245df756a3c3b6bf75ab72" => :mavericks
    sha1 "00c541a276de2938ffff968174c4b3076943a136" => :mountain_lion
  end

  def install
    system "make"
    mv "prodigal2", "prodigal" if build.head?
    bin.install "prodigal"
    doc.install "CHANGES", "LICENSE", "VERSION", "README.md"
  end

  test do
    assert_match "#{version}", shell_output("prodigal -v 2>&1")
  end
end
