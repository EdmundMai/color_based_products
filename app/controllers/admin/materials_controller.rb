class Admin::MaterialsController < Admin::BaseController
  def create
    @material = Material.new(material_params)
    unless @material.save
      @material = nil
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def material_params
      params.require(:material).permit(:name)
    end
    
end