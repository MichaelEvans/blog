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
    end
  end
end

Liquid::Template.register_tag('google_plus', Jekyll::GooglePlusEmbedTag)
