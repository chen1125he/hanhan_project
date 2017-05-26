class Admin::CommentsController < ApplicationController

  before_action :set_comment, :only => [:update]

  def index
    @comments = Comment.includes([:user, :post]).all.page(params[:page]).per(PER_PAGE).order(:id => :desc)
  end

  def search
    conn = Comment.get_admin_conn params
    @comments = Comment.includes([:user, :post]).joins([[:user, :post]]).where(conn).page(params[:page]).per(PER_PAGE).order(:id => :desc)
    render "index"
  end

  def update
    if @comment.update_attribute(:show_flag, params[:update_show_flag])
      flash[:notice] = I18n.t("messages.update_success")
    else
      flash[:notice] = I18n.t("messages.update_faild")
    end
    redirect_to admin_comments_path
  end

  private
  def set_comment
    @comment = Comment.where(:id => params[:id]).first
    unless @comment.present?
      flash[:error] = I18n.t("messages.no_data")
      redirect_to admin_comments_path
    end
  end
end
