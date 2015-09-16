class LicensesController < InheritedResources::Base
  respond_to :json

  def index
    index! { @licenses = @licenses.order('created_at ASC') }
  end
end
