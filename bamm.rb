class Bamm < Formula
  desc "Bayesian analysis of macroevolutionary mixture models on phylogenies"
  homepage "http://bamm-project.org"
  url "https://github.com/macroevolution/bamm/archive/v2.5.0.tar.gz"
  sha256 "526eef85ef011780ee21fe65cbc10ecc62efe54044102ae40bdef49c2985b4f4"
  head "https://github.com/macroevolution/bamm.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0089543"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d69a44a7bf8aaccffdce9ac637c4a2135b5b9a07109ee47bc63275db8a9b363" => :sierra
    sha256 "0895f0659fbe00742ca8644d5a9c93dae9b89afeb10a4c61dbc3b0450bc46b97" => :el_capitan
    sha256 "6c80230ab8ff97e1295391e79ce3975296d3dcd94aecc1fe9e155e719d6029da" => :yosemite
    sha256 "d2d80c21c79680b279b4d2c5f6149eb083ad7cc4e17c60845c6dfe0533bdf6c3" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install Dir["examples/*"]
  end

  test do
    cp Dir["#{pkgshare}/diversification/whales/*"], "."
    system "#{bin}/bamm", "-c", "divcontrol.txt"
  end
end
