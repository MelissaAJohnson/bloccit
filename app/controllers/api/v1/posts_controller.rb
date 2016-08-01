class Api::V1::PostsController < Api::V1::BaseController
  before_action :authenticate_user
  before_action :authorize_user

  def show
    post = Post.find(params[:id])
    render json: post, include: :comments, status: 200
  end

  def index
    posts = Post.all
    render json: post, status: 200
  end
end
