class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_own_bbcodes, only: [:index, :show]
  require 'bb-ruby'

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @posts.each do |post|
      post.post = post.post.bbcode_to_html(@imagetag)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post.post = @post.post.bbcode_to_html_with_formatting(@imagetag)
  end

  # GET /posts/new
  def new
    if not current_user.nil?
      @post = Post.new
      @photo = Photo.new
      @photos = Photo.all.where(post_id: nil)
      render 'posts/new'
    else
      redirect_to posts_path
    end

  end

  # GET /posts/1/edit
  def edit
    @photo = Photo.new
    @photos = Photo.all.where(post_id: @post.id)
    if not current_user.nil?
      render 'posts/edit'
    else
      redirect_to posts_path
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    if not current_user.nil?
      @post = Post.new(post_params)

      respond_to do |format|
        if @post.save

          # connect all photos with empty photo_id to this post
          photos = Photo.all.where(post_id: nil)
          photos.each do |photo|
            photo.post_id = @post.id
            photo.save
          end

          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_path
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if not current_user.nil?
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_path
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if not current_user.nil?
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to posts_path
    end
  end

  private
    def set_own_bbcodes
      @imagetag = {
        'Image' => [
          /\[img(:.+)?\]([^\[\]].*?)\[\/img\1?\]/im,
          '<img src="\2" alt="" class="img-thumbnail" />',
          'Quote with citation',
          '[quote=mike]please quote me[/quote]',
          :image
          ]
      }

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:header, :post)
    end
end
