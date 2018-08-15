class PagesController < ApplicationController
  def show
    if valid_page?
      render template: "pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  def home
  end

  def jobsamples
    # 218 Gusto, 21 Automattic, 13 Khan, 154 Slalom
    @jobs = Job.where(id: [218,21,13,154])
  end

  private

  def valid_page?
    File.exist?(Pathname.new(Rails.root + "app/views/pages/#{params[:page]}.html.erb"))
  end
end
