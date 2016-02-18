class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.17.3/nextflow"
  version "0.17.3"
  sha256 "05563ee1474fbef22f65fa3080792dcb08d218dd1b1561c517ebff4346559dbe"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f8c9666a8f517dfafa6851b501a560df8d13ca046b9e66e29c628841d840432" => :el_capitan
    sha256 "95ea8b93ce0d43db3503ff82081b8f45e2478ef6b409cd02c50b0085d56fb163" => :yosemite
    sha256 "a2a5dc3142e13c239df59a91c34ffc43aa30d0abf8f46ee6cebc001c054833ff" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system "#{bin}/nextflow", "-download"
    system "echo", "println \'hello\' | #{bin}/nextflow -q run - |grep hello"
  end
end
