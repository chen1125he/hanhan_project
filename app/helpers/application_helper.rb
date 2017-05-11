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
end
