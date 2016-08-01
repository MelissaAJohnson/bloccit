class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user, except: :show
  before_action :authorize_user, except: :show

  def show
    comment = Comment.find(params[:id])
    render json: comment, status: 200
  end

  def index
    comments = Comment.all
    render json: comments.to_json, status: 200
  end
end
