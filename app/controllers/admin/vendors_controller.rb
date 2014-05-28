class Admin::VendorsController < Admin::BaseController
  def create
    @vendor = Vendor.new(vendor_params)
    unless @vendor.save
      @vendor = nil
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def vendor_params
    params.require(:vendor).permit(:name)
  end
  
end