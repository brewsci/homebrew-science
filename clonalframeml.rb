class Clonalframeml < Formula
  homepage "https://code.google.com/p/clonalframeml/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1004041"
  version "1.7"

  bottle do
    cellar :any
    sha256 "09ccaab46eea44a62ffc6e2bda598099a6f83ba36c10855be99796529976a344" => :yosemite
    sha256 "d927b125595ec16af0e5e4b7f483dbd538737cf8b932c441baadcfeef235c9c0" => :mavericks
    sha256 "9215a9f0a8bcb333f6be6c9986c8a5d62dcf9160b690d5ad7937005e8cfc0daa" => :mountain_lion
    sha256 "bbd38c6efff78aff6e692d996aff80f4b978f9fabd0519986d529622fdbf2b96" => :x86_64_linux
  end

  if OS.mac?
    url "https://drive.google.com/uc?id=0B4J1jPwfCMKYREVEcU1MeVk5RWs&export=download",
      :using => NoUnzipCurlDownloadStrategy
    sha256 "fc95a31b2d77aa520aaf662a54d5059a4b6dad22af6895ab86776c2c99c8abc4"
  elsif OS.linux?
    url "https://drive.google.com/uc?id=0B4J1jPwfCMKYQnpEWkp2X0lBN28&export=download",
      :using => NoUnzipCurlDownloadStrategy
    sha256 "01fbb108f4036e728e3e56bcdd157da344bdad3a5240910767a47fb16a564108"
  else
    raise "Unsupported operating system"
  end

  def install
    bin.install "uc" => "ClonalFrameML"
  end

  test do
    assert_match "recombination", shell_output("ClonalFrameML 2>&1", 13)
  end
end
