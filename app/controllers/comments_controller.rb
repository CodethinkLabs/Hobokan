class CommentsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  auto_actions_for :item, [:create]

  def create_for_item
    hobo_create do
      redirect_to( @comment.item, :action => "show" )
    end
  end
end

