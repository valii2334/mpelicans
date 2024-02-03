# frozen_string_literal: true

# Methods used by views in companies
module CompanyHelper
  def company_title
    return 'MPelicans - How It Works' if params[:action] == 'how_it_works'
    return 'MPelicans - About Us'     if params[:action] == 'about_us'

    'MPelicans - View Pictures From Amazing Places'
  end
end
