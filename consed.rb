require "formula"

class Consed < Formula
  homepage "http://bozeman.mbt.washington.edu/consed/consed.html"
  #doi "10.1101/gr.8.3.195" => "1998", "10.1093/bioinformatics/btt515" => "2013"

  version "27.0"
  if OS.mac?
    url "http://bozeman.mbt.washington.edu/consed/distributions/#{version}/consed_mac.tar.gz"
    sha1 "3fe5b303573c645bb072b570176de1e13eb1bae3"
  elsif OS.linux?
    url "http://bozeman.mbt.washington.edu/consed/distributions/#{version}/consed_linux.tar.gz"
    sha1 "64a5a5e28b1fb5653b89b9b09b9da2749dc42d4f"
  else
    raise "Unknown operating system"
  end

  depends_on :x11

  def install
    prefix.install Dir["*"]
    bin.install_symlink Dir[prefix/"consed_*"]
    bin.install_symlink "../consed_mac_intel" => "consed" if OS.mac?
    bin.install_symlink "../consed_rhel4linux64bit_static" => "consed" if OS.linux?
  end

  test do
    system "#{bin}/consed -printDefaultResources"
  end
end
