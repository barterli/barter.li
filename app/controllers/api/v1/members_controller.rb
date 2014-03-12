class MembersController < Api::V1::BaseController
  before_action :authenticate_user!
  
  def join_group
    @group = Group.find(params[:group_id])
    if(@group.is_private?)
      Notifier.group_membership_request(@group, current_user.id).deliver
      @member = @group.members.new(:user_id => current_user.id, :status => Code[:membership][:unapproved])
      notice = "Request has been sent to the group owner for approval"
    else
      @member = @group.members.new(:user_id => current_user.id, :status => Code[:membership][:approved])
      notice = "Membership added successfully"
    end
    respond_to do |format|
      if @member.save
      	flash[:notice] = notice
        format.html { redirect_to @group}
        format.json { render action: 'show', status: :created, location: @group }
      else
      	flash[:alert] = "error"
        format.html { redirect_to @group }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end
 
end
