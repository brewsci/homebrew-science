class Bowtie2 < Formula
  homepage "http://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"
  head "https://github.com/BenLangmead/bowtie2.git"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.2.5.tar.gz"
  sha256 "fbbd630596d066f84c925d08db854d448b9780d672702e13bd76648133ac92e2"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "67239a1075d5116d7833b0a04b18c9efed3f4fb27510a9dfc0546d52afce0a63" => :yosemite
    sha256 "0c84c5e5505dc7ef83c7da6ba691948cebf2c9cd68a0b051dd67e347908f9eea" => :mavericks
    sha256 "fd0bda8aec4d0d9a1f9b433d465fed2c026d1b88ea44688315fbde892d9d64a9" => :mountain_lion
  end

  def install
    system "make"
    bin.install %W[bowtie2
                   bowtie2-align-l bowtie2-align-s
                   bowtie2-build   bowtie2-build-l   bowtie2-build-s
                   bowtie2-inspect bowtie2-inspect-l bowtie2-inspect-s]

    doc.install %W[AUTHORS LICENSE MANUAL
                   NEWS README TUTORIAL VERSION]

    share.install %W[example scripts]
  end

  test do
    system "bowtie2-build", "#{share}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end
