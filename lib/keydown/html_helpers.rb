module Keydown
  module HtmlHelpers

    def stylesheet(src)
      %Q{<link href="#{src}" rel="stylesheet" type="text/css"/>}
    end

    def script(src)
      %Q{<script src="#{src}" type="text/javascript"></script>}
    end
  end
end