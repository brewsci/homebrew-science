class Gingr < Formula
  homepage "https://github.com/marbl/harvest/blob/master/docs/content/gingr.rst"
  head "https://github.com/marbl/gingr.git"
  bottle do
    cellar :any
    sha256 "d69a4838bd3bd1b4a04350fb70edadf53fbe17483de891bd725137f0a7ae517e" => :yosemite
    sha256 "78a2e101e83eecd5154d2fe1ca0e5d07e84fb347d4752a4558a2fd06614ff67d" => :mavericks
    sha256 "0a44460b5bd6c4f046dafb223e80146b458e8480699dcc065f164e4e069a4036" => :mountain_lion
    sha256 "3e1bc092e65cb6c15fdb087c7569a6e233879ee0686cc42eb95787fc89c5a141" => :x86_64_linux
  end

  # tag "bioinformatics"
  # doi "10.1186/s13059-014-0524-x"

  if OS.mac?
    url "https://github.com/marbl/gingr/releases/download/v1.2/gingr-OSX64-v1.2.zip"
    sha256 "27ba08606ae3f743ffdbcb6d554048ab3a7560087577f10503a0f5cd0227f9d3"
  elsif OS.linux?
    url "https://github.com/marbl/gingr/releases/download/v1.2/gingr-Linux64-v1.2.tar.gz"
    sha256 "21ffb3c6fe0b70b8a872c638325e8b4d1ad18514f9888c1c1ac9e81c09d90503"
  else
    raise "Unsupported operating system"
  end

  def install
    if OS.mac?
      prefix.install "../Gingr.app"
    else
      bin.install "gingr"
    end
  end
end
