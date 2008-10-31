class Wikis < Application
  # provides :xml, :yaml, :js

  # GET /wikis
  def index
    @wikis = Wiki.all
    display @wikis
  end

  # GET /wikis/:id
  def show
    @wiki = Wiki[params[:id]]
    raise NotFound unless @wiki
    display @wiki
  end

  # GET /wikis/new
  def new
    only_provides :html
    @wiki = Wiki.new(params[:wiki])
    render
  end

  # POST /wikis
  def create
    @wiki = Wiki.new(params[:wiki])
    if @wiki.save
      redirect url(:wiki, @wiki)
    else
      render :new
    end
  end

  # GET /wikis/:id/edit
  def edit
    only_provides :html
    @wiki = Wiki[params[:id]]
    raise NotFound unless @wiki
    render
  end

  # PUT /wikis/:id
  def update
    @wiki = Wiki[params[:id]]
    raise NotFound unless @wiki
    if @wiki.update(params[:wiki])
      redirect url(:wiki, @wiki)
    else
      raise BadRequest
    end
  end

  # DELETE /wikis/:id
  def destroy
    @wiki = Wiki[params[:id]]
    raise NotFound unless @wiki
    if @wiki.destroy
      redirect url(:wikis)
    else
      raise BadRequest
    end
  end

end
