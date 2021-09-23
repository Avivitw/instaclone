# frozen_string_literal: true

class ProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @users = if params[:username]&.present?
               User.where(username: params[:username])
             else
               User.limit(20)
             end
  end

  def show
    # Load user to get user's id from username
    @user = User.find_by! username: params[:username]

    # load both directions of relationship
    @friendship_requested = Friendship.where(:requester => current_user[:id], :requested => @user.id).first()
    @friendship_received = Friendship.where(:requester => @user.id, :requested => current_user[:id]).first()
    
    # Load actual "Approved" relationships in both directions for displaying list
    @friends_list_received = Friendship.where(:requested => @user.id, :status => "Approved")
    @friends_list_requested = Friendship.where(:requester => @user.id, :status => "Approved")
    
  end

  def friend_request

    # The user we are requesting from
    @requested = User.find_by! username: params[:username]

    @friend = Friendship.new

    @friend.requester = current_user
    @friend.requested = @requested
    @friend.status = "Request" # Request / Approved / Rejected
    if @friend.save
      redirect_to [:profiles,params[:username]], notice: 'your friend request sent!'
    else
      redirect_to [:profiles], notice: 'something went wrong'
    end
  end

end
