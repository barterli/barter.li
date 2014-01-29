class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :manage_members, :membership_approval]
  before_action :authenticate_user!, only: [:create, :update, :destroy, :index]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  
  end

  # GET groups/:id/manage_members
  def manage_members
    @members = @group.members
    render :template => "groups/members"
  end

  # GET groups/:id//membership_approval
  def membership_approval
    @members = @group.members.where(:status => Code[:membership][:unapproved])
    render :template => "groups/members"
  end

  # POST /membership_status
  def assign_membership_status
    @member = @group.members.where(:user_id => params[:user_id])
    @member.status = params[:status]
    respond_to do |format|
      if @member.save
        format.html { redirect_to @group, notice: 'Updated Successfully' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'membership_approval' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_user.groups.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = current_user.groups.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:title, :description, :is_private)
    end
end
