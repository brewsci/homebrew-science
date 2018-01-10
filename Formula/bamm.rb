class Bamm < Formula
  desc "Bayesian analysis of macroevolutionary mixture models on phylogenies"
  homepage "http://bamm-project.org"
  url "https://github.com/macroevolution/bamm/archive/v2.5.0.tar.gz"
  sha256 "526eef85ef011780ee21fe65cbc10ecc62efe54044102ae40bdef49c2985b4f4"
  revision 1
  head "https://github.com/macroevolution/bamm.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0089543"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c4295e628b243e6cd85e1f59e79d6f7bf43fa508df47890aae453818db18b9" => :sierra
    sha256 "99f45e11d780cf97756b4a604a506da08fefcf91b36e56fda1ce5c5109d58d59" => :el_capitan
    sha256 "90b5f38bca30a76810d90f50983d51662eb37abcfe60ce820621bbfbba191653" => :yosemite
    sha256 "60fe664cf3346316a525b3783fe39a1066defe862b02da2f0af8db8078a2b708" => :x86_64_linux
  end

  depends_on "cmake" => :build

  fails_with :gcc => "4.8" do
    cause "Error: Enable multithreading to use std::thread"
  end

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
