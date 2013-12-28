After do |scenario|
  if scenario.status == :failed
    save_and_open_page
  end
end

module Webrat
  module SaveAndOpenPage
    def save_and_open_page
      return unless File.exist?(Webrat.configuration.saved_pages_dir)

      filename = "#{Webrat.configuration.saved_pages_dir}/webrat-#{Time.now.to_i}.html"

      File.open(filename, "w") do |f|
        f.write rewrite_public_file_references(response_body)
      end

      open_in_browser(filename)
    end

    def rewrite_public_file_references(response_html)
      # remove conditional comments/ie stylesheets
      response_html.gsub!(/<!--\[.*?\]-->/im, '')
      # remove other stylesheets
      response_html.gsub!(/<link href=(.*)\/>/i, '')

      response_html.gsub!(/("|')\/(stylesheets|images|javascripts)/, '\1' + '../public' + '/\2')

      response_html.gsub!(/<\/head>/i, "<style>#{rewrite_public_stylesheet_image_references('\/images', '../public')}<\/style>\n<\/head>")
    end

    def rewrite_public_stylesheet_image_references(regex, server_url)
      dir = "/Users/jkinney/Sites/Rails/Client/new_rails_app/public/stylesheets/"

      stylesheets = %w(reset admin main js_menu css_tabs firefox)

      css = ""
      stylesheets.each do |file|
        # puts file
        lines = []
        File.open(dir+file+".css", "r"){|f| lines = f.readlines }
        lines = lines.inject([]){|l, line| l << line.gsub(/#{regex}/i, "#{server_url}/images")}
        css << lines.to_s
      end
      css
    end

  end
end