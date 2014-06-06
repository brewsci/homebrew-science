require 'formula'

class Bioawk < Formula
  homepage 'https://github.com/lh3/bioawk'
  version "5e8b41d"
  url "https://github.com/lh3/bioawk/archive/#{version}.tar.gz"
  sha1 "1042e98bfa6a8601488df1be29eb758b2359826d"
  head 'https://github.com/lh3/bioawk.git'

  def install
    ENV.j1
    system 'make'
    bin.install 'bioawk'
    doc.install 'README.md'
    man1.install({'awk.1' => 'bioawk.1'})
  end

  test do
    system 'bioawk --version'
  end
end
