class Admin::ColorsController < Admin::BaseController
  def create
    @color = Color.new(color_params)
    unless @color.save
      @color = nil
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def color_params
      params.require(:color).permit(:name)
    end
  
end