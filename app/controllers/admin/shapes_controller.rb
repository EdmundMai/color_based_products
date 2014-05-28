class Admin::ShapesController < Admin::BaseController
  def create
    @shape = Shape.new(shape_params)
    unless @shape.save
      @shape = nil
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def shape_params
      params.require(:shape).permit(:name)
    end
    
end