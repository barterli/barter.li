class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :new]
  before_action :set_group, only: [:index, :show, :create, :new, :update]
  before_action :verify_membership, only: [:create, :new]

  # GET groups/:group_id/posts
  # GET /posts.json
  def index
    #@posts = Post.joins(group: :members).where("(posts.group_id = #{params[:group_id]} AND posts.publish_type = #{Code[:publish_type][:public]}) or members.user_id = #{current_user.id}")
     @posts = @group.posts.where(:publish_type => Code[:publish_type][:public])
     @posts <<  Post.joins(group: :members).where("posts.group_id = #{params[:group_id]} AND members.user_id = #{current_user.id} AND members.status = #{Code[:membership][:approved]}")
     @posts  = @posts.flatten.uniq 
  end


  # GET groups/:group_id/posts/1
  # GET /posts/1.json
  def show
     @post =  @group.posts.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = @group.posts.new
  end

  # GET groups/:group_id/posts/1/edit
  def edit
    @post = current_user.posts.find(params[:id])
  end

  # POST groups/:group_id/posts
  # POST /posts.json
  def create
    raise 'Unauthorized' unless check_group_post_permission
    @post = @group.posts.new(post_params)
    @post.user_id = current_user.id
    respond_to do |format|
      if @post.save
        format.html { redirect_to [@group,@post], notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT groups/:group_id/posts/1
  # PATCH/PUT groups/:group_id/posts/1.json
  def update
    @post = current_user.posts.find(params[:id])
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [@group, @post], notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE groups/:group_id/posts/1
  # DELETE groups/:group_id/posts/1.json
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id]) 
    end

    def check_group_post_permission
      @member = @group.members.find_by(:user_id => current_user.id)
      return false unless @member.present?
      status = @member.status.to_i == 1 ? true : false
      return status
    end

    def verify_membership
      @member = @group.members.find_by(:user_id => current_user.id)
      is_member = @member.present? ? true : false 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:group_id, :body, :title, :publish_type)
    end
end
