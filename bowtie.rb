class Bowtie < Formula
  desc "Ultrafast memory-efficient short read aligner"
  homepage "http://bowtie-bio.sourceforge.net/index.shtml"
  # doi "10.1186/gb-2009-10-3-r25"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie/archive/v1.1.2.tar.gz"
  sha256 "717145f12d599e9b3672981f5444fbbdb8e02bfde2a80eba577e28baa4125ba7"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    cellar :any
    sha256 "5a6d33f6249513718c44a77c2cba1ce6b94eb6fffc897b988c6c2944e0c5726b" => :yosemite
    sha256 "6ad165cc8526e5c601de52f75706f1dbc9f028b004751df1de2a49165d221db7" => :mavericks
    sha256 "04b8e3cb0a30b88f9771546b41b76a926a04c4be02bab0392ea62b41361c3817" => :mountain_lion
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    (share/"bowtie").install "scripts", "genomes", "indexes", "reads"

    inreplace share/"bowtie/scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
    end
  end

  test do
    system "perl", share/"bowtie/scripts/test/simple_tests.pl"
  end
end
