class Oswitch < Formula
  desc "Docker environments to work with Bioinformatics tools"
  homepage "https://github.com/yeban/oswitch"
  url "https://github.com/yeban/oswitch/archive/v0.2.6.tar.gz"
  sha256 "af3ce13305be8747242dc11bdd35360b568ea738be8c490d448915d4c675871f"

  bottle do
    cellar :any_skip_relocation
    sha256 "364c344dec0c3a41ea59c76df5be6bb63106894ad55d8df68ec4dcd3f3104bb7" => :el_capitan
    sha256 "33c34d78279af4034cae565ea10cb3bbffe34c32929255e34f6ce063ce8d5ee0" => :yosemite
    sha256 "b515c7a7ca13560f075bb04559b7f8758f446de59627d3ae8f928e450e888d1d" => :mavericks
  end

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
