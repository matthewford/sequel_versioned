class Comments < Application
  # provides :xml, :yaml, :js
  before :find_parents
  # GET /comments/new
  def new
    only_provides :html
    @comment = Comment.new(params[:comment])
    render
  end

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      @page.add_comment(@comment)
      @page.save
      redirect url(:wiki_page, @wiki, @page)
    else
      render :new
    end
  end

  # GET /comments/:id/edit
  def edit
    only_provides :html
    @comment = Comment[params[:id]]
    raise NotFound unless @comment
    render
  end

  # PUT /comments/:id
  def update
    @comment = Comment[params[:id]]
    raise NotFound unless @comment
    if @comment.update(params[:comment])
      redirect url(:comment, @comment)
    else
      raise BadRequest
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment = Comment[params[:id]]
    raise NotFound unless @comment
    if @comment.destroy
      redirect url(:comments)
    else
      raise BadRequest
    end
  end

  def find_parents
    @wiki = Wiki[params[:wiki_id]]
    @page = Page[params[:page_id]]
  end

end
