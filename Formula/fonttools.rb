class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/d0/82/7508f35aa3a13a07d9e28785797db3189a0dd9a2366a6314591074f811f3/fonttools-4.18.1.zip"
  sha256 "9054ec33beb043d7d5bd48a7964eb9f8a42464de9f9a335768de4ee183e64551"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a9f36af7ec6c64152dfd95f875fe00d3a3e11a7b1b1bb80425ac8bb435aa19f" => :big_sur
    sha256 "a10eb2cbd10dcee3579acd1c7ad6a4cee20d3843883f9b2a957cde9a5dffe3b6" => :catalina
    sha256 "8e85e062949689308c138692222e140a29a8ccb21da7349936fcb5498c082667" => :mojave
    sha256 "722425aa974ba695e8af5d5becb06d84a10fb7ecf5d5e45f4bfa184ead85f015" => :x86_64_linux
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
