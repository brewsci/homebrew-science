class Oswitch < Formula
  desc "Docker environments to work with Bioinformatics tools"
  homepage "https://github.com/yeban/oswitch"
  url "https://github.com/yeban/oswitch/archive/v0.2.7.tar.gz"
  sha256 "69090f628213fb93dccedbd8772d462fb7100c20c4495d4079d5f4d9bb84524c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9116ee150225d41e743fd5c8bc6bbdee6d321bceef3965c98b4accd295f0274d" => :sierra
    sha256 "1b6a33ff6685f43895d6f83d1b5cdb0d7a92ffa75b99a11c056373f258c9fdf4" => :el_capitan
    sha256 "f9302eed7c95b20561f3d4156bedd954e0c91683606748aa91640f10f01a04eb" => :yosemite
    sha256 "a98bb8326752204b0e3117c37c8457a15026a9b4b83980d3affe210290b3efdd" => :x86_64_linux
  end

  depends_on :ruby => "2.0" if OS.linux?

  def install
    # Build gem and install to prefix.
    system "gem", "build", "oswitch.gemspec"
    system "gem", "install", "-i", prefix, "oswitch-#{version}.gem"

    # Re-write RubyGem generated bin stub to load oswitch from prefix.
    inreplace "#{bin}/oswitch" do |s|
      s.gsub!(/require 'rubygems'/,
        "ENV['GEM_HOME']='#{prefix}'\nrequire 'rubygems'")
    end
  end
end
