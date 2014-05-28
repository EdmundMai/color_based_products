class Admin::VariantsController < Admin::BaseController
  
  def remove
    if params[:id].present?
      variant = Variant.find(params[:id])
      variant.destroy
    end
    @index = params[:index]
    respond_to do |format|
      format.js
    end
  end
end