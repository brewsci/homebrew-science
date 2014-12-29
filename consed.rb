require "formula"

class Consed < Formula
  homepage "http://bozeman.mbt.washington.edu/consed/consed.html"
  #doi "10.1101/gr.8.3.195" => "1998", "10.1093/bioinformatics/btt515" => "2013"
  #tag "bioinformatics"

  version "28.0"
  if OS.mac?
    url "http://bozeman.mbt.washington.edu/consed/distributions/#{version}/consed_mac.tar.gz"
    sha1 "58594afada7666b807f28217d7cf3ca76e53dcec"
  elsif OS.linux?
    url "http://bozeman.mbt.washington.edu/consed/distributions/#{version}/consed_linux.tar.gz"
    sha1 "2df1ee47fd7e7d7e370346fb04596cfdaa63082d"
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
    system "#{bin}/consed", "-printDefaultResources"
  end
end
