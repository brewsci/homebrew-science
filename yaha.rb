class LinuxRequirement < Requirement
  fatal true
  satisfy OS.linux?
  def message
    "This software only builds on Linux."
  end
end

class Yaha < Formula
  desc "Long-read alignment with optimal breakpoint detection"
  homepage "https://github.com/GregoryFaust/yaha"
  # doi "10.1093/bioinformatics/bts456"
  # tag "bioinformatics"

  url "https://github.com/GregoryFaust/yaha/releases/download/v0.1.83/yaha-0.1.83.tar.gz"
  sha256 "76e052cd92630c6e9871412e37e46f18bfbbf7fc5dd2f345b3b9a73eb74939ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "910564c95a23c3ad0297e00f56177a5fb2f22244ecc924415e25e38af87c90e5" => :x86_64_linux
  end

  # Uses Linux header file: https://github.com/Homebrew/homebrew-science/pull/2373
  depends_on LinuxRequirement

  def install
    inreplace "Makefile", "CPPFLAGS := ", "CPPFLAGS := -fpermissive "
    system "make"
    bin.install "bin/yaha"
    doc.install Dir["YAHA_User_Guide*.pdf"], "README.md", "LICENSE.txt"
    pkgshare.install "testdata"
  end

  test do
    system "yaha"
  end
end
