class Sratoolkit < Formula
  homepage "http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  version "2.3.5-2"
  if OS.mac?
    url "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/#{version}/sratoolkit.#{version}-mac64.tar.gz"
    sha1 "7238ec47089710c626a6fe0610382653c0767cec"
  elsif OS.linux?
    url "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/#{version}/sratoolkit.#{version}-ubuntu64.tar.gz"
    sha1 "9e05eb581cdc0a9cde794042800cfea5532c3b94"
  end

  head "https://github.com/NCBITools/sratoolkit.git"

  def install
    bin.mkdir
    cp Dir["bin/*[a-z]"].select {|x| File.symlink? x}, bin
    share.install "schema"
  end

  test do
    system "#{bin}/fastq-dump", "--version"
  end
end
