require 'formula'

class Sratoolkit < Formula
  homepage 'http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software'
  url 'http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.3.5-2/sratoolkit.2.3.5-2-mac64.tar.gz'
  version '2.3.5-2'
  sha1 '7238ec47089710c626a6fe0610382653c0767cec'
  head 'https://github.com/NCBITools/sratoolkit.git'

  def install
    bin.mkdir
    cp Dir['bin/*[a-z]'].select {|x| File.symlink? x}, bin
    share.install "schema"
  end

  test do
    system 'fastq-dump --version'
  end
end
