class PageDetails < Application
  # provides :xml, :yaml, :js

  # GET /page_details/:id/edit
  def edit
    only_provides :html
    @page_detail = PageDetail[params[:id]]
    raise NotFound unless @page_detail
    render
  end

  # PUT /page_details/:id
  def update
    @page_detail = PageDetail[params[:id]]
    raise NotFound unless @page_detail
    if @page_detail.update(params[:page_detail])
      redirect url(:page_detail, @page_detail)
    else
      raise BadRequest
    end
  end

end
