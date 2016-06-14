class Mapsembler2 < Formula
  desc "targeted assembly software"
  homepage "https://colibread.inria.fr/software/mapsembler2/"
  url "http://www.irisa.fr/symbiose/people/ppeterlongo/mapsembler2_2.2.4.zip"
  sha256 "e25f911ada8222ad982ebaf2c1a30e5c74b81edc3b7613879299e620e77b4ec7"
  # doi "10.1186/1471-2105-13-48"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb2d5170bb6a8cd1180816a650114812a5a1f46d7b2679f8626a3e8ca5b998f8" => :x86_64_linux
  end

  fails_with :clang do
    build 703
    cause "error: no member named 'malloc' in namespace 'std'"
  end

  fails_with :gcc => "5" do
    cause "undefined reference to `prefix_trashable[abi:cxx11]'"
  end

  depends_on "cmake" => :build

  def install
    system "./compile_all_tools.sh"
    bin.install "run_mapsembler2_pipeline.sh", Dir["tools/*"]
    doc.install "EXAMPLE.md", "LICENCE.md", "README.md", Dir["docs/*"]
  end

  test do
    system "#{bin}/run_mapsembler2_pipeline.sh", "-h"
  end
end
