require 'tilt/template'

class MarkdownHtmlFilterTemplate < Tilt::Template
  self.default_mime_type = "text/html"

  def self.engine_initialized?
    defined? ::Html::Pipeline
  end

  def initialize_engine
    require 'html/pipeline'
  end

  def prepare
    @engine = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::AbsoluteSourceFilter
    ], image_base_url: "http://utensil.github.io/", 
    image_subpage_url: "http://utensil.github.io/", 
    gfm: true, unsafe: true, tagfilter: false
  end

  # highlight.js reads the language from a class on the code element and
  # auto-detects ("guesses") any block without one. commonmarker emits the fence
  # language as <pre lang="X"> — an attribute highlight.js ignores — so every
  # block gets auto-highlighted, including prose/text. Treat these as plain.
  PLAIN_LANGS = %w[text txt plaintext plain none md].freeze

  def evaluate(scope, locals, &block)
    @output ||= begin
      html = @engine.call(data)[:output].to_s
      # AbsoluteSourceFilter only rewrites relative image paths when image_base_url
      # has a scheme+host, so it emits http://utensil.github.io/... — mixed content
      # on the https Pages site. Rewrite those image srcs to root-relative so they
      # adapt to protocol and host automatically (external images are left alone).
      html = html.gsub(%r{(src=["'])https?://utensil\.github\.io/}, '\1/')
      # Bridge the fence language onto <code> as a class so highlight.js honors it
      # instead of guessing; mark text/unlabeled blocks nohighlight so they stay plain.
      html = html.gsub(%r{<pre lang="([^"]*)"><code>}) do
        lang = Regexp.last_match(1)
        cls = (lang.empty? || PLAIN_LANGS.include?(lang.downcase)) ? 'nohighlight' : lang
        %(<pre><code class="#{cls}">)
      end
      html.gsub('<pre><code>', '<pre><code class="nohighlight">')
    end
  end

end