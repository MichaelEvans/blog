module Jekyll

  class GooglePlusEmbedTag < Liquid::Tag
    @post = nil
    @height = ''
    @width = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /(https:\/\/plus.google.com\/\d+\/posts\/\w+)/i
        @url  = $1
      end
      super
    end

    def render(context)
      "<div align='center'><div class='g-post' data-href='#{@url}'></div></div>"
      # if @video.size > 0
      #   video =  "<video width='#{@width}' height='#{@height}' preload='none' controls poster='#{@poster}'>"
      #   @video.each do |v|
      #     t = v.match(/([^\.]+)$/)[1]
      #     video += "<source src='#{v}' #{type[t]}>"
      #   end
      #   video += "</video>"
      # else
      #   "Error processing input, expected syntax: {% video url/to/video [url/to/video] [url/to/video] [width height] [url/to/poster] %}"
      # end
    end
  end
end

Liquid::Template.register_tag('google_plus', Jekyll::GooglePlusEmbedTag)
