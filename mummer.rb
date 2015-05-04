class Mummer < Formula
  homepage "http://mummer.sourceforge.net/"
  # doi "10.1186/gb-2004-5-2-r12"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "155182ed24450891d6799ec0367716de3b7bf109715b8441f83f196d9fedc3b7" => :yosemite
    sha256 "d2bc2b64b9623aa6426d2ecc2405a6583f9cebe3dbb074681798fb3649d750b9" => :mavericks
    sha256 "68a8351484551600a6f81bac291cd1f2b4cb2176188a87d322b671740bc754a9" => :mountain_lion
  end

  # annotate conflicts with gd
  TOOLS = %w[
    combineMUMs delta-filter dnadiff exact-tandems mapview mgaps
    mummer mummerplot nucmer promer repeat-match
    run-mummer1 run-mummer3 show-coords show-diff show-snps show-tiling]

  def install
    prefix.install Dir["*"]
    cd prefix do
      system "make"
      rm_r "src"
    end
    TOOLS.each { |tool| bin.install_symlink "../#{tool}" }
  end

  test do
    TOOLS.each do |tool|
      system "#{bin}/#{tool} -h 2>&1 |grep -i Usage"
    end
  end
end
