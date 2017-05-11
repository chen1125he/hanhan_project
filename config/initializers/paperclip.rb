require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
Paperclip.options[:command_path] = 'C:\\Program Files\\ImageMagick-7.0.5-Q16'

#https://github.com/thoughtbot/paperclip/issues/1405
#http://stackoverflow.com/questions/21912322/ruby-on-rails-paperclip-error