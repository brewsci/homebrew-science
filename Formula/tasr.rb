class Tasr < Formula
  desc "Targeted assembler of short sequence reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/tasr"
  # doi "10.1371/journal.pone.0019816"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/tasr/releases/1.6.2/tasr_v1-6-2.tar.gz"
  version "1.6.2"
  sha256 "8e92f58a4f0a5b986f581299b81c9447a2805b3da2a7b8afa1f5254ba8126207"

  bottle do
    cellar :any_skip_relocation
    sha256 "b146f9a09e036d98838511d022bdf7c5d8be7da715ec2b0fb28b4737ca191a6a" => :sierra
    sha256 "d1cafc9e722f0a11c0a3779f34beba08c0da433cefa203b1d0375a2a93195077" => :el_capitan
    sha256 "d1cafc9e722f0a11c0a3779f34beba08c0da433cefa203b1d0375a2a93195077" => :yosemite
    sha256 "5429552c804c0ac15a386cea6b50490316d25dd7dbf205958269ffe2ffc25d79" => :x86_64_linux
  end

  def install
    bin.install "TASR"
    bin.install "TASR-Bloom"
    doc.install "TASR-readme.txt"
    pkgshare.install %w[test tools lib]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/TASR", 255)
  end
end
