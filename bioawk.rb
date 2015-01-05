require "formula"

class Bioawk < Formula
  homepage "https://github.com/lh3/bioawk"
  version "5e8b41d"
  url "https://github.com/lh3/bioawk/archive/#{version}.tar.gz"
  sha1 "1042e98bfa6a8601488df1be29eb758b2359826d"
  head "https://github.com/lh3/bioawk.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ed7b2bcdf5420729429d7c30450250bd1fa4b4d6" => :yosemite
    sha1 "7093a34c9ad55cd869aaa2973bd6777c239d6734" => :mavericks
    sha1 "75262055989014fd83dd0023b8d3a44a1f2ad8ea" => :mountain_lion
  end

  depends_on "bison" => :build

  def install
    ENV.j1
    system "make"
    bin.install "bioawk"
    doc.install "README.md"
    man1.install({"awk.1" => "bioawk.1"})
  end

  test do
    system "bioawk --version"
  end
end
