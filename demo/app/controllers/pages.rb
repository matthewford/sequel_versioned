class Pages < Application
  provides :xml, :yaml, :js
  
  before :load_wiki

  # GET /pages
  def index
    @pages = @wiki.pages
    display @pages
  end

  # GET /pages/:id
  def show
    version = params[:version]
    @page = Page[params[:id]]
    @page.fetch_version = version if version
    @page_detail = @page.fetch_page_detail
    @comments = @page.fetch_comments
    @comment = Comment.new(:version => version || @page.comments_version)
    raise NotFound unless @page_detail
    display @page
  end

  # GET /pages/new
  def new
    @page = Page.new(:wiki_id => @wiki.pk)
    @page.save
    only_provides :html
    render
  end

  # GET /pages/:id/edit
  def edit
    only_provides :html
    version = params[:version]    
    @page = Page[params[:id]]
    @page.fetch_version = version if version
    raise NotFound unless @page
    render
  end

  # PUT /pages/:id
  def update
    @page = Page[params[:id]]
    @page.version! if params[:version_page]
    raise NotFound unless @page
    detail = @page.fetch_page_detail
    detail.update(params[:page_detail])
    redirect url(:wiki_page, @wiki, @page)
  end

  # DELETE /pages/:id
  def destroy
    @page = Page[params[:id]]
    raise NotFound unless @page
    if @page.destroy
      redirect url(:pages)
    else
      raise BadRequest
    end
  end
  
  def load_wiki
    @wiki = Wiki[params[:wiki_id]]
  end

end
