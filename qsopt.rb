class Qsopt < Formula
  desc "Creating, manipulating, and solving LP problems"
  homepage "http://www.math.uwaterloo.ca/~bico/qsopt/index.html"
  if OS.mac?
    url "http://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/mac64/qsopt"
    sha256 "fa2f135eb6fa14e4c27abc97549ab032f56155170bbe27d2c0094245fe55e60e"
  else
    url "http://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/linux64/qsopt"
    sha256 "d030c3eea14ea57d96c5b5f85212dde8cf6e3239d7a1522143cc3af960c31b4c"
  end
  version "1.01"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6b1a86ff5c3febe9e3914497113c9fc55e6812cbe0949ea816dfde2f67988484" => :el_capitan
    sha256 "4786b3521799135fa59b7aa15064572b024c04a4162ad1bfdc9bcaa4f499bfe1" => :yosemite
    sha256 "c8d642603ae5db27641860f8e194b4b2b2f370512322ae895c0b5f41d81bbb23" => :mavericks
  end

  resource "qsopt.h" do
    url "http://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/mac64/qsopt.h"
    sha256 "647729f1bd77e1263ecf35e1897c705ef1cb45e2d65dbd9cb8fdf5df5ae65624"
  end

  resource "qsopt.a_mac" do
    url "http://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/mac64/qsopt.a"
    sha256 "95c636054d5b5755c3e98a01d101c6b9292a647b2ac77c6857b0c1f19e43a97e"
  end

  resource "qsopt.a_linux" do
    url "http://www.math.uwaterloo.ca/~bico/qsopt/beta/codes/linux64/qsopt.a"
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
