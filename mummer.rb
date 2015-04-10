class Mummer < Formula
  homepage "http://mummer.sourceforge.net/"
  # doi "10.1186/gb-2004-5-2-r12"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "2d940173a9f828bfcfc51f5039fa8deb2698703b" => :yosemite
    sha1 "520904995c105a2579fec678acc24c0214a2ed04" => :mavericks
    sha1 "78a0688d0c6d181c0dc7cfdf7ca1bf1f0eaf87fd" => :mountain_lion
  end

  TOOLS = %w[
    annotate combineMUMs delta-filter dnadiff exact-tandems mapview mgaps
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
      system "#{bin}/#{tool} -h 2>&1 |grep #{tool}"
    end
  end
end
