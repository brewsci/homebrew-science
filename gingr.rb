class Gingr < Formula
  homepage "https://github.com/marbl/harvest/blob/master/docs/content/gingr.rst"
  head "https://github.com/marbl/gingr.git"
  # tag "bioinformatics"
  # doi "10.1186/s13059-014-0524-x"

  if OS.mac?
    url "https://github.com/marbl/gingr/releases/download/v1.2/gingr-OSX64-v1.2.zip"
    sha1 "c848640f5987eacf1fd3bf7ec4a59e72fc2d59e9"
  elsif OS.linux?
    url "https://github.com/marbl/gingr/releases/download/v1.2/gingr-Linux64-v1.2.tar.gz"
    sha1 "b1f3e9f31bbc3510aa2d9b286643dd465ca61e13"
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

  test do
    # gingr no longer supports command line options, only GUI
  end
end
