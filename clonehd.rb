class Clonehd < Formula
  desc "High-definition reconstruction of clonal composition"
  homepage "http://www.sanger.ac.uk/science/tools/clonehd"
  url "https://github.com/ivazquez/cloneHD/archive/v1.17.9.tar.gz"
  sha256 "176b5002a4bd51eab35c73ab799271ace35f6db2f1bdecc9fd0f0a85e45d0e46"
  head "https://github.com/ivazquez/cloneHD.git"
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
