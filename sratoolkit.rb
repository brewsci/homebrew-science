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
    sha1 "68c928823a62834f786a5177fb5e355ae37a5317" => :yosemite
    sha1 "66c945ae9b6f84cbdde18456c898734f9927a57e" => :mavericks
    sha1 "ff305cfd27ed3b1147384a32a921cf06661e3b67" => :mountain_lion
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
