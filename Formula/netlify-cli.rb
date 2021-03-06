require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.8.tgz"
  sha256 "db9f3d61922f9a04c99cfc21a761b9871facc39baabb59d98dfed8f7372a286e"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aa90e8e25e9d330b601e3624310a15b5eef0a99fd4334c16f8095c9086fa2475" => :big_sur
    sha256 "1575034f9056eb2092e908ffa90f1cfd0999ea2befb8b7cacac4b3305899c99f" => :catalina
    sha256 "8b5db861f458a1d5c196d19bcdef67d19241d7396d72278abc111fefdcd7a3d7" => :mojave
    sha256 "8014c27b422c1924d09f9400bafe1c02e83ddc840f9bfad227b4c6034c481280" => :x86_64_linux
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
