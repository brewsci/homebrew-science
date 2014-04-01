require "formula"

class TCoffee < Formula
  homepage "http://www.tcoffee.org/"
  version "10.00.r1613"
  url "https://github.com/cbcrg/tcoffee/archive/v#{version}.tar.gz"
  sha1 "47650472c339470bcf2eda0ff117a8ed723f7802"
  head "https://github.com/cbcrg/tcoffee.git"
  #doi "10.1006/jmbi.2000.4042"

  def install
    system *%w[make -C compile t_coffee]
    prefix.install "lib" => "libexec"
    prefix.install Dir["*"]
    bin.install_symlink "../compile/t_coffee"
  end

  test do
    system "#{bin}/t_coffee -version"
  end
end
