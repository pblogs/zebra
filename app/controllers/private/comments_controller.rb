class Private::CommentsController < ApplicationController
  filter_access_to :all

  def create
    comment = Comment.new params[:comment]

    if comment.save
      flash[:success] = "Comment saved"
    else
      flash[:error] = "Please write comment's text"
    end

    redirect_to :back
  end

end
