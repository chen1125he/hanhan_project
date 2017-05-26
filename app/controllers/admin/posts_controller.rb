class Admin::PostsController < ApplicationController

  before_action :set_post, :only => [:edit, :update]

  def index
    @posts = Post.includes([:user, :plate]).all.page(params[:page]).per(PER_PAGE)
  end

  def search
    conn = Post.get_conn params
  end

  def edit

  end

  def update
    @post.update_attribute(:post_status, params[:post][:post_status])
    flash[:notice] = I18n.t("messages.update_success")
    redirect_to admin_posts_path
  end

  private
  def set_post
    @post = Post.where(:id => params[:id]).first
    unless @post.present?
      flash[:error] = I18n.t("messages.no_data")
      redirect_to posts_path
    end
  end
end
