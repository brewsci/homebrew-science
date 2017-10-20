class Qsopt < Formula
  desc "Creating, manipulating, and solving LP problems"
  homepage "https://www.math.uwaterloo.ca/~bico/qsopt/"
  if OS.mac?
    url "https://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/mac64/qsopt"
    sha256 "fa2f135eb6fa14e4c27abc97549ab032f56155170bbe27d2c0094245fe55e60e"
  else
    url "https://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/linux64/qsopt"
    sha256 "d030c3eea14ea57d96c5b5f85212dde8cf6e3239d7a1522143cc3af960c31b4c"
  end
  version "1.01"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "858c18d9b0427e53c23ee721d5006d85a053958bb36d77a37918509b04742304" => :el_capitan
    sha256 "cf2871b135eaa4b2baa8caf9448fdad2b792a27eb60665ec610904caa655f5a4" => :yosemite
    sha256 "cecf58bacb0e005dcbd27554c29e2397e5c9daf8eb57344424f7283ddfc631f8" => :mavericks
    sha256 "08aeb8140fdffbf9c9e02d02b0828207686d3083ebbd8f948785320011e55de6" => :x86_64_linux
  end

  resource "qsopt.h" do
    url "https://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/mac64/qsopt.h"
    sha256 "647729f1bd77e1263ecf35e1897c705ef1cb45e2d65dbd9cb8fdf5df5ae65624"
  end

  resource "qsopt.a_mac" do
    url "https://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/mac64/qsopt.a"
    sha256 "95c636054d5b5755c3e98a01d101c6b9292a647b2ac77c6857b0c1f19e43a97e"
  end

  resource "qsopt.a_linux" do
    url "https://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/linux64/qsopt.a"
    sha256 "41d7cbd2f9cd6575370120f3f8336593cb461f3d87f6c6934a23171a0cc4c28b"
  end

  def install
    bin.install "qsopt"
    include.install resource("qsopt.h")
    if OS.mac?
      lib.install resource("qsopt.a_mac")
    else
      lib.install resource("qsopt.a_linux")
    end
  end

  test do
    (testpath/"test.lp").write <<-'EOF'.undent
    Problem
           smallExample
    Maximize
        obj: x - 2.3y + 0.5z
    Subject
        c1: x - y + s <= 10.75
            -z + 2x - s >= -100
    End
    EOF
    system "qsopt", "test.lp"
  end
end
