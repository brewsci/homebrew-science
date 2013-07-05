require 'formula'

class SnpSites < Formula
  homepage 'https://github.com/sanger-pathogens/snp_sites'
  url 'ftp://ftp.sanger.ac.uk/pub/pathogens/software/snp_sites/snp_sites-1.tar.gz'
  sha1 'ee4ded1bcb9486b0ee454cf592b4286e891269ab'
  head 'https://github.com/sanger-pathogens/snp_sites.git'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "snp_sites"
  end
end
