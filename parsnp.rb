class Parsnp < Formula
  homepage "https://github.com/marbl/parsnp"
  #tag "bioinformatics"
  #doi "10.1186/s13059-014-0524-x"

  head "https://github.com/marbl/parsnp.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "eb6802a03f95fcd3f9d918ce03aea2f2da3cafc8" => :yosemite
    sha1 "63d40206dcf353a9624e3f10913a17b2f1a6915d" => :mavericks
    sha1 "8090d479662d6aae0d5e8f395f7e1aaba4fc976d" => :mountain_lion
  end

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
