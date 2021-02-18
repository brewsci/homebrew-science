class Mapsembler2 < Formula
  desc "Targeted assembly software"
  homepage "https://colibread.inria.fr/software/mapsembler2/"
  url "https://www.irisa.fr/symbiose/people/ppeterlongo/mapsembler2_2.2.4.zip"
  sha256 "e25f911ada8222ad982ebaf2c1a30e5c74b81edc3b7613879299e620e77b4ec7"
  revision 1
  # doi "10.1186/1471-2105-13-48"
  # tag "bioinformatics"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 high_sierra:  "742ca2dfb2e550d1d839f0542a3809b939ad381fd18e1de336ca86eaad71a36a"
    sha256 sierra:       "87d29c6ce1f393616c1862c7effe4af85a749b33695e7c16c5ca3de5ac441580"
    sha256 el_capitan:   "87e6addec277034fc54f47a4895a62ffd5bf29208805568063308b7906cc8bfb"
    sha256 x86_64_linux: "50882b30ad388b0fda3ccd9d0e37d389541227549468d0db240201560176df94"
  end

  depends_on "cmake" => :build

  fails_with :clang do
    build 703
    cause "error: no member named 'malloc' in namespace 'std'"
  end

  def install
    system "./compile_all_tools.sh"
    bin.install "run_mapsembler2_pipeline.sh", Dir["tools/*"]
    doc.install "EXAMPLE.md", "LICENCE.md", "README.md", Dir["docs/*"]
  end

  test do
    system "#{bin}/run_mapsembler2_pipeline.sh", "-h"
  end
end
