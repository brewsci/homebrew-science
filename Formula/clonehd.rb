class Clonehd < Formula
  desc "High-definition reconstruction of clonal composition"
  homepage "https://www.sanger.ac.uk/science/tools/clonehd"
  url "https://github.com/ivazquez/cloneHD/archive/v1.17.9.tar.gz"
  sha256 "176b5002a4bd51eab35c73ab799271ace35f6db2f1bdecc9fd0f0a85e45d0e46"
  revision 1
  head "https://github.com/ivazquez/cloneHD.git"

  bottle do
    sha256 "3edb63f909f26b3de79d4ad84831cea510d9de2dc92147b4e1974215b81718e5" => :sierra
    sha256 "3b6afecd2818f5bfeba72226901629a60b0263ffd085ee3165bff3c04df7aeb2" => :el_capitan
    sha256 "a76e462eeeea666f1fd731c180ced9a494e81848bc5291cd8aa3bf81aed28d58" => :yosemite
    sha256 "55192610eaf3931d0b0ff9d6404ee7fba44d236a9989cfebdb618555b870f6d5" => :x86_64_linux
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
