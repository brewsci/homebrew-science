class Clonehd < Formula
  desc "High-definition reconstruction of clonal composition"
  homepage "http://www.sanger.ac.uk/science/tools/clonehd"
  url "https://github.com/ivazquez/cloneHD/archive/v1.17.9.tar.gz"
  sha256 "176b5002a4bd51eab35c73ab799271ace35f6db2f1bdecc9fd0f0a85e45d0e46"
  head "https://github.com/ivazquez/cloneHD.git"
  bottle do
    sha256 "8ee4733510ff68c206f5a5ce8ae554bef0cdfd5986b9cbebf9d54e591dc774d2" => :el_capitan
    sha256 "debd6eb1f17dd3dcb613e2ce73e8cd087dbbf5f1163b384d89a3e407eb19e675" => :yosemite
    sha256 "aef26cbb76e8df98d9e876b37815804dc7053db999cf81e427c039e06c0980cd" => :mavericks
    sha256 "0c23dfd1e0c4c3f030d9efd58749835fd0a24d241dc4f10fee5fe4d21bbf1b4d" => :x86_64_linux
  end

  # doi "10.1016/j.celrep.2014.04.055"
  # tag "bioinformatics"

  depends_on "gsl"

  # Use OpenMP and avoid building with clang/LLVM
  needs :openmp

  def install
    mkdir_p "build"
    cd "src" do
      system "make"
    end
    bin.install Dir["build/*"]
    doc.install Dir["docs/*"]
    pkgshare.install Dir["test/data/*"]
  end

  test do
    system "#{bin}/cloneHD", "--help"
  end
end
