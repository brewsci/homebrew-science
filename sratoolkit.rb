require 'formula'

class Sratoolkit < Formula
  homepage 'http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software'
  url 'http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.3.2-4/sra_sdk-2.3.2-4.tar.gz'
  sha1 'fb483457ae12c6f34ffecb70cf3515b5b91a9b2e'
  head 'https://github.com/NCBITools/sratoolkit.git'

  def install
    ENV.j1
    system 'make', 'static', 'release'
    system 'make'
    bin.mkdir
    cp Dir['bin64/*[a-z]'].select {|x| File.symlink? x}, bin
  end

  test do
    system 'fastq-dump --version'
  end
end
