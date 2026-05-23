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

  def evaluate(scope, locals, &block)
    # AbsoluteSourceFilter only rewrites relative image paths when image_base_url
    # has a scheme+host, so it emits http://utensil.github.io/... — mixed content
    # on the https Pages site. Rewrite those image srcs to root-relative so they
    # adapt to protocol and host automatically (external images are left alone).
    @output ||= @engine.call(data)[:output].to_s
                  .gsub(%r{(src=["'])https?://utensil\.github\.io/}, '\1/')
  end

end