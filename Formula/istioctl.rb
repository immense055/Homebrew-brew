class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.8.1",
      revision: "806fb24bc121bf93ea06f6a38b7ccb3d78d1f326"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4800b4e1f1fb2967dc36aab48dc535e9d7ea9673b94b05a381ac9e522d3a5c86" => :big_sur
    sha256 "810e84cb98f5e1d75715eb8376b44c64cdaad7be026bf8f2461cba9c814f27cf" => :catalina
    sha256 "0b5585969427eca2432fa787cb452f6bddca55398d0e17d279ca58fa909f8be7" => :mojave
    sha256 "56fdd1cd91c118453af5b0c9c4a9b8f465f846e7281c8a38b2bdfc276aff374a" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
