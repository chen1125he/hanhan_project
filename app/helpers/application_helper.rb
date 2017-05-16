module ApplicationHelper

  def admin_menu_active controller
    reg = Regexp.new(controller.to_s)
    if params[:controller] =~ reg
      'active'
    end
  end

  def replace_br str=""
   sanitize str.gsub(/\r\n/, '<br />')
  end

  def post_show_time time
    if time.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
      time.strftime("%H:%M:%S")
    else
      time.strftime("%Y-%m-%d")
    end
  end
end