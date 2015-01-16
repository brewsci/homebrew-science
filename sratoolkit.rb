class Sratoolkit < Formula
  homepage "http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  version "2.4.3"
  if OS.mac?
    url "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/#{version}/sratoolkit.#{version}-mac64.tar.gz"
    sha1 "baf9312d7185593e514806744cab7077b808a598"
  elsif OS.linux?
    url "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/#{version}/sratoolkit.#{version}-ubuntu64.tar.gz"
    sha1 "da07935448a2a1567c591e514c667aa9e3846ec3"
  end

  head "https://github.com/NCBITools/sratoolkit.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "c6b31c166049b91362bf09eb3c6ed224a62353fe" => :yosemite
    sha1 "2a626d233fcac01729454973b0f5df7d30ca1106" => :mavericks
    sha1 "789f49e088586372cd6debff51be0ec67b0d2873" => :mountain_lion
  end

  def install
    bin.mkdir
    cp Dir["bin/*[a-z]"].select {|x| File.symlink? x}, bin
    share.install "schema"
  end

  test do
    system "#{bin}/fastq-dump", "--version"
  end
end
