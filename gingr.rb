class Gingr < Formula
  homepage "https://github.com/marbl/gingr"
  head "https://github.com/marbl/gingr.git"
  #tag "bioinformatics"
  #doi "10.1186/s13059-014-0524-x"

  if OS.mac?
    url "https://github.com/marbl/gingr/releases/download/v1.0.1/gingr-OSX64-v1.0.1.zip"
    sha1 "30d6549f08a099b7a0fe278b947a3b7ce56e4c4d"
  elsif OS.linux?
    url "https://github.com/marbl/gingr/releases/download/v1.0.1/gingr-Linux64-v1.0.1.tar.gz"
    sha1 "8b43bc52340542cac1ec43aa808fa4b151187bd9"
  else
    raise "Unsupported operating system"
  end

  def install
    if OS.mac?
      prefix.install "../gingr.app"
    else
      bin.install "gingr"
    end
  end

  test do
    system "#{bin}/gingr", "-h" unless OS.mac?
  end
end
