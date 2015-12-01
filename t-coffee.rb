class TCoffee < Formula
  homepage "http://www.tcoffee.org/"
  version "10.00.r1613"
  url "https://github.com/cbcrg/tcoffee/archive/v#{version}.tar.gz"
  sha256 "8280e6002167a6adad7a238181657b1febae27c2b2edf4245027daaf55c8c763"
  head "https://github.com/cbcrg/tcoffee.git"
  # doi "10.1006/jmbi.2000.4042"

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
