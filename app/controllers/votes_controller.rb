class VotesController < ApplicationController
  before_action :require_sign_in
  respond_to :html, :js

  def up_vote
    update_vote(1)

    respond_to do |format|
      format.js { render :action => "update_vote"}
    end
  end

  def down_vote
    update_vote(-1)

    respond_to do |format|
      format.js { render :action => "update_vote"}
    end
  end

  private
  def update_vote(new_value)
    @post = Post.find(params[:post_id])
    @vote = @post.votes.where(user_id: current_user.id).first

    if @vote
      @vote.update_attribute(:value, new_value)
    else
      @vote = current_user.votes.create(value: new_value, post: @post)
    end
  end
end
