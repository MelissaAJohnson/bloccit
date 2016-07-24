class CommentsController < ApplicationController
   before_action :require_sign_in
   before_action :authorize_user, only: [:destroy]

   def create
     if params[:post_id]
       @parent = Post.find(params[:post_id])
     elsif params[:topic_id]
       @parent = Topic.find(params[:topic_id])
     end

     @comment = @parent.comments.new(comment_params)
     @comment.user = current_user

     if @comment.save
       flash[:notice] = "Comment saved successfully."
       if @parent.is_a?(Post)
         redirect_to [@parent.topic, @parent]
       elsif @parent.is_a?(Topic)
         redirect_to @parent
       end
     else
       flash[:alert] = "Comment failed to save."
       if @parent.is_a?(Post)
         redirect_to [@parent.topic, @parent]
       elsif @parent.is_a?(Topic)
         redirect_to @parent
       end
     end
   end

   def destroy
     comment = Comment.find(params[:id])

     if comment.destroy
       flash[:notice] = "Comment was deleted successfully."
       redirect_to :back
     else
       flash[:alert] = "Comment couldn't be deleted. Try again."
       redirect_to :back
     end
   end

   private

   def comment_params
     params.require(:comment).permit(:body)
   end

   def authorize_user
     comment = Comment.find(params[:id])
     unless current_user == comment.user || current_user.admin?
       flash[:alert] = "You do not have permission to delete a comment."
       redirect_to [comment.post.topic, comment.post]
     end
   end
 end
