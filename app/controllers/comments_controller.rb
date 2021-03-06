class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    unless enabled_user
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end

    if admin_user
      @comments = Comment.find(:all)
    else
      @comments = current_user.comments
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    unless enabled_user
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end
    @comment = Comment.new
    @comment.user_id = current_user.id
    if params[:comment][:parent_id]
      @comment.parent_id = params[:comment][:parent_id]
    end
    if params[:comment][:flag_id]
      @comment.flag_id = params[:comment][:flag_id]
    end
    if params[:comment][:topic_id]
      @comment.topic_id = params[:comment][:topic_id]
    end
    if params[:comment][:fallacy_id]
      @comment.parent_id = params[:comment][:fallacy_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    unless can_edit_comment(@comment)
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    unless enabled_user
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end

    @comment = Comment.new(params[:comment])
    # make sure to set the comment's user_id to the current user...
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@comment) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    unless can_edit_comment(@comment)
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    unless can_edit_comment(@comment)
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
