class PostsController < BaseController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.order('created_at DESC')
  end

  def show

  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

end