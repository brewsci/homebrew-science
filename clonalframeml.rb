class Clonalframeml < Formula
  homepage "https://code.google.com/p/clonalframeml/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1004041"
  version "1.7"

  if OS.mac?
    url "https://drive.google.com/uc?id=0B4J1jPwfCMKYREVEcU1MeVk5RWs&export=download",
      :using => NoUnzipCurlDownloadStrategy
    sha256 "fc95a31b2d77aa520aaf662a54d5059a4b6dad22af6895ab86776c2c99c8abc4"
  elsif OS.linux?
    url "https://drive.google.com/uc?id=0B4J1jPwfCMKYQnpEWkp2X0lBN28&export=download",
      :using => NoUnzipCurlDownloadStrategy
    sha256 "01fbb108f4036e728e3e56bcdd157da344bdad3a5240910767a47fb16a564108"
  else
    fail "Unsupported operating system"
  end

  def install
    bin.install "uc" => "ClonalFrameML"
  end

  test do
    assert_match "recombination", shell_output("ClonalFrameML 2>&1", 13)
  end
end
