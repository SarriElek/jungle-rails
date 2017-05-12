class Admin::AdminController < ApplicationController

  http_basic_authenticate_with name: ENV['USER_NAME'], password: ENV['USER_PASSWORD']

end
