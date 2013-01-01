class PostsController < ApplicationController
  
  before_filter :authenticate_editor!, :only => [:new, :edit, :create, :update, :destroy]
  
  # GET /posts
  # GET /posts.json
  def index
    
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).paginate(:page => params[:page])
    else
      @posts = Post.with_state(editor_signed_in? ? params[:state] : 'published').time_ordered.paginate(:page => params[:page])    
    end

    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end
    
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  def create      
    @post = Post.new(params[:post])

    if params[:save_draft]
      @post.save_draft
    elsif params[:finalize_draft]
      @post.finalize
    elsif params[:publish_draft]
      @post.publish
    elsif params[:abandon_draft]
      @post.destroy
      redirect_to posts_path, notice: 'Post has been abandoned and deleted forever.'
      return
    end
      
    if @post.save
      if @post.draft?
        redirect_to edit_post_path(@post), notice: 'Post was successfully saved.'
      else
        redirect_to @post, notice: 'Post was successfully created.' 
      end
    else
      render action: "new"
    end
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])

    # differences from create are
    # - the redirect message for the abandon button
    # - ! operators for state changes to raise errors on fail
    # - notices
    # but these two paths could likely diverge in the future, so it's ok to keep it un-dry
    if params[:save_draft]
      @post.save_draft!
    elsif params[:finalize_draft]
      @post.finalize!
      notice = 'Post was successfully finalized.' 
    elsif params[:publish_draft]
      @post.publish
      notice = 'Post was successfully published.' 
    elsif params[:abandon_draft]
      @post.toss
      redirect_to posts_path, notice: 'Post draft has been archived.'
      return
    end

    if @post.update_attributes(params[:post])
      if @post.draft?
        redirect_to edit_post_path(@post), notice: 'Post was successfully updated.'
      else
        redirect_to @post, notice: notice
      end
    else
      render action: "edit"
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end
end
