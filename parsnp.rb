class Parsnp < Formula
  homepage "https://github.com/marbl/parsnp"
  #tag "bioinformatics"
  #doi "10.1186/s13059-014-0524-x"

  head "https://github.com/marbl/parsnp.git"

  if OS.mac?
    url "https://github.com/marbl/parsnp/releases/download/v1.0/parsnp-OSX64-v1.0.tar.gz"
    sha1 "721c34434857c876fbf3f0b3aabda8145d6ee7eb"
  elsif OS.linux?
    url "https://github.com/marbl/parsnp/releases/download/v1.0/parsnp-Linux64-v1.0.tar.gz"
    sha1 "a00173f05aa30b38e5013b44297d194b2695de89"
  else
    raise "Unsupported operating system"
  end

  def install
    bin.install "parsnp"
  end

  test do
    system "#{bin}/parsnp -h |grep parsnp"
  end
end
