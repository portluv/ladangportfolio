class CreateController < ApplicationController
  before_action :set_thing, only: [:showBook]

    def index
      if session[:username]
        @user = User.find_by(username: session[:username])
      else
        redirect_to root_path
      end
    end

    def showBook
      respond_to do |format|
        format.js
      end
    end

    def convert
      dir = Rails.root.join('app','assets', 'images', 'user_assets', 'anonymous', 'asd.pdf')
      done = Docsplit.extract_images(dir, :size => '100x', output: Rails.root.join('app','assets', 'images', 'user_assets', 'anonymous'), :format => [:jpg])
    end

    def addBook
      @thing = Thing.new(thing_params)
      @thing.user_id = session[:user_id]
      if params[:path].present?
        file = params[:path]
        dir = Rails.root.join('app','assets', 'images', 'user_assets', session[:username], @thing.name) #GET DIRECTORY
        FileUtils.mkdir_p(dir) unless File.directory?(dir) #IF DIRECTORY EXISTS
        File.open(Rails.root.join(dir, "#{@thing.name}.pdf"), 'wb') do |f|
          f.write(file.read)
        end
        @thing.path = "#{session[:username]}/#{@thing.name}"
        dir = Rails.root.join(dir, "#{@thing.name}.pdf")
        Docsplit.extract_images(dir, output: Rails.root.join('app','assets', 'images', 'user_assets', session[:username], @thing.name), :format => [:jpg])
        File.delete(dir) if File.exist?(dir)
      end

      respond_to do |format|
        if @thing.save
          format.html { redirect_to create_path, notice: 'Added new Book.' }
        else
          format.html { render :index }
          format.json { render json: @thing.errors, status: :unprocessable_entity }
        end
      end
      # dir = Rails.root.join('app','assets', 'images', 'anonymous', 'asd.pdf')
      # done = Docsplit.extract_images(dir, output: Rails.root.join('app','assets', 'images', 'anonymous'), :format => [:jpg])
      # puts done
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_thing
        @thing = Thing.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def thing_params
          params.permit(:name, :path, :type, :id)
      end  
  end